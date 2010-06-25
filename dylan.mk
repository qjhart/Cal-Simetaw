#! /usr/bin/make -f 
ifndef configure.mk
include configure.mk
endif

dylan.mk:=1

.PHONY:db
db::${db}/dylan.composite ${db}/dylan.grid ${db}/dylan.soil

${db}/dylan:${db}/%:
	${PG} -c "drop schema if exists $* cascade;create schema $*;"
	touch $@

${db}/dylan.grid:${db}/%:${down}/BigGrid.shp ${db}/dylan
	shp2pgsql -s 3310 -d -g boundary -S $< $* | ${PG}
	touch $@

${db}/dylan.composite:${db}/%:${down}/composite.shp ${db}/dylan
	shp2pgsql -s 3310 -d -g boundary -S $< $* | ${PG}
	touch $@

${db}/dylan.soil:${down}/grid_awc-STATSGO.csv ${down}/grid_awc-SSURGO.csv ${down}/grid_awc-combined.csv
	cat dylan/soil.sql |\
	 sed -e "s|statsgo.csv|${down}/grid_awc-STATSGO.csv|" |\
	 sed -e "s|ssurgo.csv|${down}/grid_awc-SSURGO.csv|" |\
	 sed -e "s|combined.csv|${down}/grid_awc-combined.csv|" | ${PG} -f -
	touch $@

.PHONY: exchange

exchange:${out}/4km/soil.csv ${out}/4km/statsgo.csv ${out}/4km/ssurgo.csv

${out}/4km/soil.csv ${out}/4km/statsgo.csv ${out}/4km/ssurgo.csv :${out}/4km/%.csv: ${db}/dylan.soil
	${PG-CSV} -c "select x,y,AWC,SDx from dylan.$* order by y,x" > $@

