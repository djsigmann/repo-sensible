# TODO: figure out if icon.png can be auto-generated from icon.xcf or if must be done automatically

all:
	zip RepoSensible.zip manifest.json README.md CHANGELOG.md icon.png -r BepInEx/

clean:
	rm -f *.zip
