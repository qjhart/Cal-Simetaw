#! /usr/bin/make -f 

ifndef configure.mk
include configure.mk
endif

.PHONY:db/4km
db/4km:${db}/4km

${db}/4km:
	${PG} -f 4km/schema.sql
	touch $@

.PHONY: pixels
stations:${stations}

.PHONY:db/4km.pixels
db/4km.pixels:${db}/4km.pixels
${db}/4km.pixels:${db}/4km
	g.region rast=state@4km
	r.mask -o state@4km
	r.stats -1 -x -n -g longitude_deg@4km,latitude_deg@4km | ${PG} -c "COPY \"4km\".pixels(east,north,x,y,longitude,latitude) from STDIN WITH DELIMITER ' ';"
	touch $@

.PHONY:db/4km.cfhs
db/4km.cfhs:${db}/4km.cfhs
${db}/4km.cfhs:${db}/4km.pixels
	g.region rast=state@4km
	r.mask -o state@4km
	r.stats fs=, -1 -N -x input=cfhs@4km |\
	${PG} -c 'COPY "4km".cfhs (x,y,cfhs) from STDIN WITH CSV';
	r.mask -r
	touch $@

$(warning is_monthly ${is_monthly})
$(warning is_daily ${is_daily})

ifdef is_daily

.PHONY:4km

4km: ${db}/4km ${rast}/Tn ${rast}/Tx ${rast}/PCP ${rast}/ETo ${rast}/RF
	@g.region rast=state@4km;\
	r.mask -o input=state@4km >/dev/null 2>/dev/null;\
	date=`g.gisenv MAPSET`;\
	doy=`date --date=${date} +%j`;\
	declare -a M=(`g.gisenv MAPSET | tr '-' ' '`);\
	${PG} -c "delete from \"4km\".daily${YYYY} where ymd='$${date}'";\
	r.stats -1 -n -x fs=, input=Tn,Tx,PCP,ETo,RF 2>/dev/null |\
	sed -e "s/^/$$date,$${M[0]},$${M[1]},$${M[2]},$$doy,/" |\
	${PG} -c 'COPY "4km".daily${YYYY} (ymd,year,month,day,doy,x,y,Tn,Tx,PCP,ETo,RF) from STDIN WITH CSV';
	@r.mask -r;

endif

ifdef is_monthly

#$(warning is_monthly ${is_monthly})

.PHONY:prism
prism:${db}/4km
	g.region rast=state@4km
	r.mask -o state@4km
	declare -a M=(`g.gisenv MAPSET | tr '-' ' '`);\
	${PG} -c "delete from \"4km\".prism where year=$${M[0]} and month=$${M[1]}";\
	r.stats fs=, -1 -N -x input=mTn,mTx,mPCP,NRF |\
	sed -e "s/^/$${M[0]},$${M[1]},/" -e "s/*/999/" |\
	${PG} -c 'COPY "4km".prism (year,month,x,y,Tn,Tx,PCP,NRD) from STDIN WITH CSV';
	r.mask -r


endif

.PHONY: exchange
exchange:${out}/4km/prism.csv ${out}/4km/pixels.csv ${out}/4km/cfhs.csv


${out}/4km/prism.csv:
	${PG-CSV} -c "select x,y,year,month,tn,tx,pcp,nrd from \"4km\".prism order by x,y,year,month" > $@

${out}/4km/pixels.csv:
	${PG-CSV} -c "select x,y,east,north,longitude,latitude from \"4km\".pixels order by x,y" > $@

${out}/4km/cfhs.csv:
	${PG-CSV} -c "select x,y,cfhs from \"4km\".cfhs order by x,y" > $@

daily-csv:=$(patsubst %,${out}/4km/%.csv,${years})

${daily-csv}:${out}/4km/%.csv:
	${PG-CSV} -c "select x,y,ymd,year,month,day,doy,tx,tn,pcp from \"4km\".daily$* order by x,y,ymd" > $@






