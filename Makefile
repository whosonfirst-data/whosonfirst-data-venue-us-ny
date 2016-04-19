YMD = $(shell date +%Y%m%d)

count:
	find data -name '*.geojson' -print | wc -l

prune:
	git gc --aggressive --prune

concordances:
	wof-concordances-write -processes 100 -source ./data > meta/wof-concordances-tmp.csv
	mv meta/wof-concordances-tmp.csv meta/wof-concordances-$(YMD).csv
	cp meta/wof-concordances-$(YMD).csv meta/wof-concordances-latest.csv
