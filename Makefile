# TODO: figure out if icon.png can be auto-generated from icon.xcf or if must be done manually
all: clean gen-zip

clean:
	rm -rf build

# TODO: figure out if it's possible to generate URLS to the relevant thunderstore.io packages from dependency strings
gen-zip:
	mkdir -p build

	# generate manifest.json
	tac dependencies.txt | sed '/^djsigmann-RepoSensible/d' | sed 's/^/"/; s/$$/"/; 1s/^/[/; $$!s/$$/,/; $$s/$$/]/' | \
	jq --tab '.dependencies = input' manifest.json - >build/manifest.json

	cp -a README.md CHANGELOG.md icon.png BepInEx/ build

	cd build && \
	zip RepoSensible.zip manifest.json README.md CHANGELOG.md icon.png -r BepInEx/
