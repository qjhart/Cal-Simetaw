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
rowtable-indices:=$(patsubst %,${db}/${schema}.daily%.idx,${rows})

prism-schema:=prism4km
prism-rowtables:=$(patsubst %,${db}/${prism-schema}.prism%,${rows})

.PHONY:INFO
INFO::
	echo ${rows}

.PHONY:db
db::${db}/${schema} ${rowtables} ${prism-rowtables}

${db}/${schema}:
	${PG} --variable=dailySchema=${schema} -f daily4km/schema.sql
	touch $@

${rowtables}:${db}/${schema}.daily%:${db}/${schema}
	${PG} --variable=dailySchema=${schema} --variable=r=$* -f daily4km/add_daily4km.sql
	touch $@

rowtable-indices:${rowtable-indices}
${rowtable-indices}:${db}/${schema}.daily%:${db}/${schema}
	${PG} --variable=dailySchema=${schema} --variable=r=$* -f daily4km/add_daily4km.sql
	touch $@


${db}/${prism-schema}:
	${PG} --variable=prismSchema=${prism-schema} -f daily4km/prism.sql
	touch $@

${prism-rowtables}:${db}/${prism-schema}.prism%:${db}/${prism-schema}
	${PG} --variable=prismSchema=${prism-schema} --variable=r=$* -f daily4km/add_prism.sql
	touch $@

ifdef is_daily
.PHONY: 4km-byrow
4km-byrow: ${rast}/Tn ${rast}/Tx ${rast}/PCP ${rast}/ETo ${rast}/RF
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

endif

.PHONY: 4km
4km: ${etc}/db/4km
${etc}/db/4km: ${rast}/Tn ${rast}/Tx ${rast}/PCP ${rast}/ETo ${rast}/RF
	[[ -d ${etc}/db ]] || mkdir -p ${etc}/db
	${MASK}
	@date=`g.gisenv MAPSET`;\
	doy=`date --date=${date} +%j`;\
	declare -a M=(`g.gisenv MAPSET | tr '-' ' '`);\
	r.stats -1 -n -x fs=, input=Tn,Tx,PCP,ETo,RF 2>/dev/null |\
	sed -e "s/^/$$date,$${M[0]},$${M[1]},$${M[2]},$$doy,/" |\
	${PG} -c "COPY \"${schema}\".daily (ymd,year,month,day,doy,x,y,Tn,Tx,PCP,ETo,RF) from STDIN WITH CSV";
	${NOMASK}
	touch $@

ifdef is_monthly

#$(warning is_monthly ${is_monthly})

.PHONY: prism
prism: ${etc}/db/prism
${etc}/db/prism: ${rast}/mTn ${rast}/mTx ${rast}/mPCP ${rast}/NRF
#${etc}/db/prism:
	[[ -d ${etc}/db ]] || mkdir -p ${etc}/db
	${MASK}
	@declare -a M=(`g.gisenv MAPSET | tr '-' ' '`);\
	r.stats fs=, -1 -N -x input=mTn,mTx,mPCP,NRF |\
	sed -e "s/^/$${M[0]},$${M[1]},/" -e "s/*/999/" |\
	${PG} -c 'COPY "${prism-schema}".prism (year,month,x,y,Tn,Tx,PCP,NRD) from STDIN WITH CSV';
	${NOMASK}
	touch $@

endif




