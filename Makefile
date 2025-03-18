# TODO: figure out if icon.png can be auto-generated from icon.xcf or if must be done automatically
all: clean gen-deps
	zip RepoSensible.zip manifest.json README.md CHANGELOG.md icon.png -r BepInEx/

clean:
	rm -f *.zip manifest-tmp.json

# TODO: figure out if it's possible to generate URLS to the relevant thunderstore.io packages from dependency strings
gen-deps:
	tac dependencies.txt | sed '/^djsigmann-RepoSensible/d' | sed 's/^/"/; s/$$/"/; 1s/^/[/; $$!s/$$/,/; $$s/$$/]/' | \
	jq --tab '.dependencies = input' manifest.json - >manifest-tmp.json
	mv manifest-tmp.json manifest.json
