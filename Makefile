# There are only two rules:
# 1. Variables at the top of the Makefile.
# 2. Targets are listed alphabetically. No, really.

WHOAMI = $(shell basename `pwd`)
YMD = $(shell date "+%Y%m%d")

archive:
	echo "archive to $(dest)"
	tar --exclude='.git' -cvjf $(dest)/$(WHOAMI)-$(YMD).bz2 ./

bundles:
	echo "please write me"

# https://github.com/whosonfirst/go-whosonfirst-concordances
# Note: this does not bother to check whether the newly minted
# `wof-concordances-tmp.csv` file is the same as any existing
# `wof-concordances-latest.csv` file. It should but it doesn't.
# (20160420/thisisaaronland)

concordances:
	wof-concordances-write -processes 100 -source ./data > meta/wof-concordances-tmp.csv
	mv meta/wof-concordances-tmp.csv meta/wof-concordances-$(YMD).csv
	cp meta/wof-concordances-$(YMD).csv meta/wof-concordances-latest.csv

count:
	find ./data -name '*.geojson' -print | wc -l

gitignore:
	mv .gitignore .gitignore.$(YMD)
	curl -s -o .gitignore https://raw.githubusercontent.com/whosonfirst/whosonfirst-data-utils/master/git/.gitignore

makefile:
	mv Makefile Makefile.$(YMD)
	curl -s -o Makefile https://raw.githubusercontent.com/whosonfirst/whosonfirst-data-utils/master/make/Makefile

list-empty:
	find data -type d -empty -print

postbuffer:
	git config http.postBuffer 104857600

prune:
	git gc --aggressive --prune

rm-empty:
	find data -type d -empty -print -delete

setup:
	# Running one-time setup tasks...
	# --------
	# Configure the repository to disable oh-my-zsh’s Git status integration,
	# which performs poorly when working with large repos.
	# See: http://stackoverflow.com/questions/12765344/oh-my-zsh-slow-but-only-for-certain-git-repo
	git config --add oh-my-zsh.hide-status 1
	# --------
	# Okay, all done with setup!
