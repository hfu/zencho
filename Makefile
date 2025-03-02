SRC_PATH = src/R6.csv
download: 
	curl -o $(SRC_PATH) https://www.keishicho.metro.tokyo.lg.jp/about_mpd/jokyo_tokei/jokyo/zencho.files/R6.csv

start:
	abrg serve start

stop:
	abrg serve stop

produce:
	iconv -f CP932 $(SRC_PATH) | ruby produce.rb | ogr2ogr zencho.geojson /vsistdin/

