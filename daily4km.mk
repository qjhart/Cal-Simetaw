#! /usr/bin/make -f 
#1987=3652
#yr=1987; for d in `seq 0 3652`; do m=`date --date="${yr}-10-01 + $d days" --rfc-3339=date`; y=${m%%-*};  g.mapset -c location=$y mapset=$m; g.mremove -f vect=*; time ~/etosimetaw/bin/daily4km.mk 4km-all; done
#yr=1987; for d in `seq 0 3651`; do m=`date --date="${yr}-10-02 + $d days" --rfc-3339=date`; y=${m%%-*};  g.mapset location=$y mapset=$m; time ~/etosimetaw/bin/daily4km.mk 4km-all; done

INC:=/home/quinn/etosimetaw/bin
ifndef configure.mk
include ${INC}/configure.mk
endif

schema:=daily4km
rows:=$(shell seq -f %03g 0 299)
rowtables:=$(patsubst %,${db}/${schema}.daily%,${rows})

.PHONY:INFO
INFO::
	echo ${rows}

.PHONY:db
db::${db}/${schema} ${rowtables}

${db}/${schema}:
	${PG} --variable=dailySchema=${schema} -f daily4km/schema.sql
	touch $@

${rowtables}:${db}/${schema}.daily%:${db}/${schema}
	${PG} --variable=dailySchema=${schema} --variable=r=$* -f daily4km/add_daily4km.sql
	touch $@

.PHONY: 4km
4km: ${rast}/Tn ${rast}/Tx ${rast}/PCP ${rast}/ETo ${rast}/RF
	${MASK}
	@date=`g.gisenv MAPSET`;\
	doy=`date --date=${date} +%j`;\
	declare -a M=(`g.gisenv MAPSET | tr '-' ' '`);\
	for r in `seq -f %03g 0 300`; \
	  do R=`echo $$r | sed -e 's/^0*//'`; \
	  r.stats -1 -n -x fs=, input=Tn,Tx,PCP,ETo,RF 2>/dev/null |\
	  grep "^[0-9]*,$${R}," |\
	  sed -e "s/^/$$date,$${M[0]},$${M[1]},$${M[2]},$$doy,/" |\
	  ${PG} -c "COPY \"${schema}\".daily$${r} (ymd,year,month,day,doy,x,y,Tn,Tx,PCP,ETo,RF) from STDIN WITH CSV";\
	  echo daily$${r};\
	done; 
	${NOMASK}

4km-all: ${rast}/Tn ${rast}/Tx ${rast}/PCP ${rast}/ETo ${rast}/RF
	${MASK}
	@date=`g.gisenv MAPSET`;\
	doy=`date --date=${date} +%j`;\
	declare -a M=(`g.gisenv MAPSET | tr '-' ' '`);\
	r.stats -1 -n -x fs=, input=Tn,Tx,PCP,ETo,RF 2>/dev/null |\
	sed -e "s/^/$$date,$${M[0]},$${M[1]},$${M[2]},$$doy,/" |\
	${PG} -c "COPY \"${schema}\".daily (ymd,year,month,day,doy,x,y,Tn,Tx,PCP,ETo,RF) from STDIN WITH CSV";
	${NOMASK}





