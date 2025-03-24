# TODO: figure out if icon.png can be auto-generated from icon.xcf or if must be done manually
all: clean gen-zip

clean:
	rm -rf build

# TODO: figure out if it's possible to generate URLS to the relevant thunderstore.io packages from dependency strings
gen-zip:
	mkdir -p build

	tac dependencies.txt | sed '/^djsigmann-RepoSensible/d' >build/dependencies.txt # remove this modpack from dependencies list and reorder it

	sed 's/^/"/; s/$$/"/; 1s/^/[/; $$!s/$$/,/; $$s/$$/]/' <build/dependencies.txt >build/dependencies.json # json-ify dependencies.txt
	jq --tab '.dependencies = input' manifest.json build/dependencies.json >build/manifest.json # generate manifest.json

	sed 's|^\(.*\)-\(.*\)-\(.*\)$$|- [\2](https://thunderstore.io/c/repo/p/\1/\2/)|' <build/dependencies.txt >build/dependencies.md # generate URLS for dependencies
	sed '/## Mods/ {n; d}' README.md | sed '/## Mods/r build/dependencies.md' >build/README.md # merge README.md and dependencies.md

	cp -a CHANGELOG.md icon.png BepInEx/ build

	cd build && \
	zip RepoSensible.zip manifest.json README.md CHANGELOG.md icon.png -r BepInEx/
