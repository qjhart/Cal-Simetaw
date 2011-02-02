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

cimis-schema:=cimis4km
cimis-rowtables:=$(patsubst %,${db}/${cimis-schema}.cimis%,${rows})


.PHONY:INFO
INFO::
	echo ${rows}

.PHONY:db
db::${db}/${schema} ${db}/${schema}.pixels ${db}/${schema}.cfhs ${rowtables} ${db}/${prism-schema}.prism  ${db}/${cimis-schema}.cimis

${db}/${schema}:
	${PG} --variable=dailySchema=${schema} -f daily4km/schema.sql
	touch $@

# In reality, the 4km.pixels file should almost take precedence....
${db}/${schema}.pixels:${db}/${schema}
	g.region rast=state@4km
	r.mask -o state@4km
	r.stats -1 -x -N -g state@4km,prism_mask@4km,cimis_mask@4km | sed -e 's/\*/0/g' | ${PG} -c "COPY \"${schema}\".pixels(east,north,x,y,dwr,prism,cimis) from STDIN WITH DELIMITER ' ';"
	${PG} -c "select AddGeometryColumn('${schema}','pixels','centroid',3310,'POINT',2); select AddGeometryColumn('${schema}','pixels','boundary',3310,'POLYGON',2); update \"${schema}\".pixels set centroid=setsrid(MakePoint(east,north),3310),boundary=setsrid(Envelope(ST_MakeBox2D(MakePoint(east-2000,north-2000),MakePoint(east+2000,north+2000))),3310); update \"${schema}\".pixels set longitude=y(transform(centroid,4269)),latitude=x(transform(centroid,4269)),dwr_id=y||'_'||x;"
	touch $@

${db}/${schema}.cfhs:${db}/${schema}.pixels
	g.region rast=state@4km
	r.mask -o state@4km
	r.stats fs=, -1 -N -x input=cfhs@4km |\
	${PG} -c 'COPY "${schema}".cfhs (x,y,cfhs) from STDIN WITH CSV';
	r.mask -r
	touch $@


${rowtables}:${db}/${schema}.daily%:${db}/${schema}
	${PG} --variable=dailySchema=${schema} --variable=r=$* -f daily4km/add_daily4km.sql
	touch $@

rowtable-indices:${rowtable-indices}
${rowtable-indices}:${db}/${schema}.daily%.idx:${db}/${schema}
	${PG} --variable=dailySchema=${schema} --variable=r=$* -f daily4km/index_daily4km.sql
	touch $@

${db}/${prism-schema}:
	${PG} --variable=prismSchema=${prism-schema} -f daily4km/prism.sql
	touch $@

${db}/${prism-schema}.prism:${db}/${prism-schema} ${prism-rowtables}
	touch $@

${prism-rowtables}:${db}/${prism-schema}.prism%:${db}/${prism-schema}
	${PG} --variable=prismSchema=${prism-schema} --variable=r=$* -f daily4km/add_prism.sql
	touch $@

${db}/${cimis-schema}:
	${PG} --variable=cimisSchema=${cimis-schema} -f daily4km/cimis.sql
	touch $@

${db}/${cimis-schema}.cimis:${db}/${cimis-schema} ${cimis-rowtables}
	touch $@

${cimis-rowtables}:${db}/${cimis-schema}.cimis%:${db}/${cimis-schema}
	${PG} --variable=cimisSchema=${cimis-schema} --variable=r=$* -f daily4km/add_cimis.sql
	touch $@

ifdef is_daily

.PHONY:4km-cimis

4km-cimis: ${etc}/db/4km
${etc}/db/4km: ${rast}/Tn ${rast}/Tx ${rast}/U2 ${rast}/es ${rast}/ea ${rast}/Rs ${rast}/Rnl  ${rast}/K ${rast}/et0
	[[ -d ${etc}/db ]] || mkdir -p ${etc}/db
	${MASK}
        @g.region rast=state@4km;\
        doy=`date --date=${date} +%j`;\
	@date=`g.gisenv MAPSET`;\
        r.stats -1 -n -x fs=, input=Tn,Tx,U2,Tdew,es,ea,Rs,Rnl,K,et0 2>/dev/null |\
        sed -e "s/^/${date},${YYYY},${MM},${DD},$${doy},/" |\
        ${PG} -c 'COPY cimis4km.cimis (ymd,year,month,day,doy,x,y,Tn,Tx,U2,Tdew,es,ea,Rs,Rnl,k,et0) from STDIN WITH CSV';
	touch $@

# .PHONY: 4km
# 4km: ${etc}/db/4km

# ${etc}/db/4km: ${rast}/Tn ${rast}/Tx ${rast}/PCP ${rast}/ETo ${rast}/RF
# 	[[ -d ${etc}/db ]] || mkdir -p ${etc}/db
# 	${MASK}
# 	@date=`g.gisenv MAPSET`;\
# 	doy=`date --date=${date} +%j`;\
# 	declare -a M=(`g.gisenv MAPSET | tr '-' ' '`);\
# 	r.stats -1 -n -x fs=, input=Tn,Tx,PCP,ETo,RF 2>/dev/null |\
# 	sed -e "s/^/$$date,$${M[0]},$${M[1]},$${M[2]},$$doy,/" |\
# 	${PG} -c "COPY \"${cimis-schema}\".cimis (ymd,year,month,day,doy,x,y,Tn,Tx,PCP,ETo,RF) from STDIN WITH CSV";
# 	${NOMASK}
# 	touch $@

endif

ifdef is_monthly

#$(warning is_monthly ${is_monthly})

.PHONY: prism
prism: ${etc}/db/prism
${etc}/db/prism: ${rast}/mTn ${rast}/mTx ${rast}/mPCP ${rast}/NRF
	[[ -d ${etc}/db ]] || mkdir -p ${etc}/db
	${MASK}
	@declare -a M=(`g.gisenv MAPSET | tr '-' ' '`);\
	r.stats fs=, -1 -N -x input=mTn,mTx,mPCP,NRF |\
	sed -e "s/^/$${M[0]},$${M[1]},/" -e "s/*/999/" |\
	${PG} -c 'COPY "${prism-schema}".prism (year,month,x,y,Tn,Tx,PCP,NRF) from STDIN WITH CSV';
	${NOMASK}
	touch $@

endif




