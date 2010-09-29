#! /usr/bin/make -f

#here is the info on the NCDC/NOAA data access
#http://www.ncdc.noaa.gov/oa/about/ncdchelp.html#FREE
#http://www.ncdc.noaa.gov/oa/samples/coopform.txt 

# Basically, you need to go through the climate data access at
# http://cdo.ncdc.noaa.gov/.  You choose the US Daily data set, with
# advanced options.  Then limit by California, use file based, Ouput
# format is delimited with No Station Names, comma w/ data flags.  You
# have to do this from a computer that has reverse DNS lookup.
# Matthias has some nice examples of this in my mail

#perl -i.bak -n -e 'print unless /^----/' *dat.txt


#select count(*) from weather where m NOT IN ('E','M','S','(');

ifndef configure.mk
include configure.mk
endif

#downloads:=2569932115797  5963302115799  9286862115800 \
#2404074213582 7985364213578 3565564213569 8792304213571

downloads:=2404074213582 7985364213578 3565564213569 8792304213571 1997-2007

stations:=$(patsubst %,db/ncdc.%stn.txt,${downloads})
weather:=$(patsubst %,db/ncdc.%dat.txt,${downloads})

db/ncdc:
	${PG} -f ncdc/schema.sql
	touch $@

.PHONY: stations
stations:${stations}

${stations}:db/%:../data/%
	cat ncdc/add_station.sql | sed -e "s|stn.txt|`pwd`/$<|" | ${PG} -f -
	touch $@

.PHONY: weather
weather:${weather}

${weather}:db/%:../data/%
	cat ncdc/add_weather.sql | sed -e "s|dat.txt|`pwd`/$<|" | ${PG} -f -
	touch $@

db/ncdc.prism.${MAPSET}:db/ncdc.prism.%:${rast}/mTx ${rast}/mTn ${rast}/mPCP
	$(PG) -c "delete from ncdc.prism where year=${YYYY} and month=${MM}";
	$(PG) -F' ' -A -t -c "select x(centroid),y(centroid),station_id|| \
	'|${YYYY}|${MM}' from ncdc.station" |\
	r.what input=mTn@$*,mTx@$*,mPCP@$* |\
	cut --delimiter="|" --fields='3-'  |\
	${PG} -c "COPY ncdc.prism from STDIN using delimiters '|' with NULL as '*'"; 
#	touch $@

db/ncdc.m_delta_weather: db/ncdc
	${PG} -f ncdc/delta_weather.sql
	touch $@

csv-all-tables:=$(patsubst %,${out}/ncdc.%.csv,mflags qflags weather)
csv-tables:=${csv-all-tables} ${out}/ncdc.station.csv

.PHONY: csv zip
csv:${csv-tables}

${out}/ncdc.station.csv:
	${PG-CSV} -c "select station_id,coopid,wbnid,name,country,state,county,cd,latitude,longitude,elevation from ncdc.station" > $@

${csv-all-tables}:${out}/%.csv:
	${PG} -c '\copy $* TO $@ CSV'
#	${PG-CSV} -c "select * from $*" > $@

zip:${out}/ncdc.zip
${out}/ncdc.zip:${csv-tables}
	zip $@ ${csv-tables}