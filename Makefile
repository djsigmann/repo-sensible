.PHONY: all mk-builddir gen-manifest gen-readme gen-icon gen-zip clean 

all: clean gen-zip

mk-builddir:
	mkdir -p build

gen-dependencies: mk-builddir
	tac dependencies.txt | sed '/^djsigmann-RepoSensible/d' >build/dependencies.txt # remove this modpack from dependencies list and reorder it

gen-manifest: mk-builddir gen-dependencies
	sed 's/^/"/; s/$$/"/; 1s/^/[/; $$!s/$$/,/; $$s/$$/]/' <build/dependencies.txt >build/dependencies.json # json-ify dependencies.txt
	jq --tab '.dependencies = input' manifest.json build/dependencies.json >build/manifest.json # generate manifest.json

gen-readme: mk-builddir gen-dependencies
	sed 's|^\(.*\)-\(.*\)-\(.*\)$$|- [\2](https://thunderstore.io/c/repo/p/\1/\2/)|' <build/dependencies.txt >build/dependencies.md # generate URLS for dependencies
	sed '/## Mods/ {n; d}' README.md | sed '/## Mods/r build/dependencies.md' >build/README.md # merge README.md and dependencies.md

gen-icon: mk-builddir
	magick icon.xcf -layers merge -resize 256x256 build/icon.png # export icon.xcf to png (requires imagemagick)

gen-zip: mk-builddir gen-manifest gen-readme gen-icon
	cp -a CHANGELOG.md BepInEx/ build
	cd build && \
	zip RepoSensible.zip manifest.json README.md CHANGELOG.md icon.png -r BepInEx/

clean:
	rm -rf build
