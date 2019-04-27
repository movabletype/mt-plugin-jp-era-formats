zip:
	cd .. && zip -r mt-plugin-jp-era-formats/mt-plugin-jp-era-formats.zip mt-plugin-jp-era-formats -x *.git* */t/* */.travis.yml */Makefile

clean:
	rm mt-plugin-jp-era-formats.zip

