#! /usr/bin/make -f 

ifndef configure.mk
include configure.mk
endif

.PHONY:db
db::${db}/4km ${db}/4km.pixels ${db}/4km.cfhs

${db}/4km:
	${PG} -f 4km/schema.sql
	${PG} -f 4km/cimis.sql
	touch $@

.PHONY: pixels
stations:${stations}

# In reality, the 4km.pixels file should almost take precedence....
.PHONY:db/4km.pixels
db/4km.pixels:${db}/4km.pixels
${db}/4km.pixels:${db}/4km
	g.region rast=state@4km
#	r.mask -r
	r.mask -o state@4km
	r.stats -1 -x -N -g state@4km,prism_mask@4km,cimis_mask@4km | sed -e 's/\*/0/g' | ${PG} -c "COPY \"4km\".pixels(east,north,x,y,dwr,prism,cimis) from STDIN WITH DELIMITER ' ';"
	${PG} -c "select AddGeometryColumn('4km','pixels','centroid',3310,'POINT',2); select AddGeometryColumn('4km','pixels','boundary',3310,'POLYGON',2); update \"4km\".pixels set centroid=setsrid(MakePoint(east,north),3310),boundary=setsrid(Envelope(ST_MakeBox2D(MakePoint(east-2000,north-2000),MakePoint(east+2000,north+2000))),3310); update \"4km\".pixels set longitude=y(transform(centroid,4269)),latitude=x(transform(centroid,4269)),dwr_id=y||'_'||x;"
	touch $@

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
	${MASK}
	date=`g.gisenv MAPSET`;\
	doy=`date --date=${date} +%j`;\
	declare -a M=(`g.gisenv MAPSET | tr '-' ' '`);\
	${PG} -c "delete from \"4km\".daily where ymd='$${date}'";\
	r.stats -1 -n -x fs=, input=Tn,Tx,PCP,ETo,RF 2>/dev/null |\
	sed -e "s/^/$$date,$${M[0]},$${M[1]},$${M[2]},$$doy,/" |\
	${PG} -c 'COPY "4km".daily (ymd,year,month,day,doy,x,y,Tn,Tx,PCP,ETo,RF) from STDIN WITH CSV';
	${NOMASK}

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


ifdef is_daily

.PHONY:4km-cimis

4km-cimis: ${rast}/Tn ${rast}/Tx ${rast}/U2 ${rast}/es ${rast}/ea ${rast}/Rs ${rast}/Rnl  ${rast}/K ${rast}/eto
	@g.region rast=state@4km;\
	r.mask -o input=state@4km >/dev/null 2>/dev/null;\
	date=`g.gisenv MAPSET`;\
	doy=`date --date=${date} +%j`;\
	declare -a M=(`g.gisenv MAPSET | tr '-' ' '`);\
#	${PG} -c "delete from \"4km\".cimis where ymd='$${date}'";\
	r.stats -1 -n -x fs=, input=Tn,Tx,U2,Tdew,es,ea,Rs,Rnl,K,et0 2>/dev/null |\
	sed -e "s/^/$$date,$${M[0]},$${M[1]},$${M[2]},$$doy,/" |\
	${PG} -c 'COPY "4km".cimis (ymd,year,month,day,doy,x,y,Tn,Tx,U2,Tdew,es,ea,Rs,Rnl,k,et0) from STDIN WITH CSV';
	@r.mask -r;

endif


#
# Outputs
#

.PHONY: exchange
exchange:${out}/4km/prism.csv ${out}/4km/pixels.csv ${out}/4km/cfhs.csv


${out}/4km/prism.csv:
	${PG-CSV} -c "select x,y,year,month,tn,tx,pcp,nrd from \"4km\".prism order by x,y,year,month" > $@

${out}/4km/pixels.csv:
	${PG-CSV} -c "select x,y,east,north,longitude,latitude,dwr_id,dwr,prism,cimis from \"4km\".pixels order by x,y" > $@

${out}/4km/cfhs.csv:
	${PG-CSV} -c "select x,y,cfhs from \"4km\".cfhs order by x,y" > $@

.PHONY: cimis.csv

define cimis-row.csv
cimis.csv::${out}/4km/cimis_${1}x.csv
${out}/4km/cimis_${1}x.csv:
	rm -f $$@;
	for i in 0 1 2 3 4 5 6 7 8 9; do \
	${PG-CSV} -c "select x,y,ymd,d.year,d.month,d.day,d.doy,CASE WHEN c is not null THEN c.Tx ELSE d.Tx END as Tx,case WHEN c is not null then c.Tn else d.tn END as Tn,c.Rs,c.K,c.U2,(ln(c.ea/0.6108)*237.30/(17.27-ln(c.ea/0.6108)))::decimal(10,2) as Tdew,d.pcp, CASE WHEN c is not null then c.et0 else d.eto END as eto,d.rf,case when c is not null then True else False END as cimis from \"4km\".daily_${1}$$$$i d left join \"4km_byrow\".cimis_${1}$$$$i c using (x,y,ymd) order by x,y,ymd" >> $$@; \
	done;
endef

#daily-csv:=$(patsubst %,${out}/4km/%.csv,${years})
#${daily-csv}:${out}/4km/%.csv:
#	${PG-CSV} -c "select x,y,ymd,year,month,day,doy,tx,tn,pcp from \"4km\".daily$* order by x,y,ymd" > $@

define daily-row.csv
daily.csv::${out}/4km/daily_${1}x.csv
${out}/4km/daily_${1}x.csv:
	rm -f $$@;
	for i in 0 1 2 3 4 5 6 7 8 9; do \
	${PG-CSV} -c "select x,y,ymd,year,month,day,doy,Tx,Tn,pcp,eto,rf from \"4km\".daily_${1}$$$$i d  order by x,y,ymd" >> $$@; \
	done; \
	perl -n -i -e 'print unless (/^x/ && $$$$x==1);$$$$x=1;' $$@
endef


rows:=00 01 02 03 04 05 06 07 08 09 \
10 11 12 13 14 15 16 17 18 19 \
20 21 22 23 24 25 26

$(foreach i,${rows},$(eval $(call cimis-row.csv,$i)))
$(foreach i,${rows},$(eval $(call daily-row.csv,$i)))



