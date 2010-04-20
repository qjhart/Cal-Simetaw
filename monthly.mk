#! /usr/bin/make --include-dir=/home/quinn/etosimetaw/bin -f 

# This setup was for a multi-day setup.  I'm not sure that's the best
# idea, so some of this is going in the daily.mk file as well.  (one
# mapset only

ifndef configure.mk
include configure.mk
endif

ifdef is_monthly

mapsets:=$(shell g.mapsets -l | tr ' ' "\n" | grep ${MAPSET}-..)
#mapsets:=$(shell ${PG} -t -c "select date from ncdc.dates where date::text ~'${YYYY}-${MM}-.{2}'")

.PHONY: NRF NRD
NRD:$(rast)/NRD
NRF:$(rast)/NRF

${rast}/NRF ${rast}/NRD:${rast}/N%:
	r.mapcalc '$(notdir $@)=$(patsubst %,"$*@%"+,${mapsets})0'

.PHONY:TnTxPCPNRF.csv
TnTxPCPNRF.csv:${etc}/TnTxPCPNRF.csv
${etc}/TnTxPCPNRF.csv: ${rast}/mTn ${rast}/mTx ${rast}/mPCP ${rast}/NRF
	@[[ -d $(dir $@) ]]  || mkdir $(dir $@);\
	g.region rast=state@4km;\
	r.mask -r input=MASK >/dev/null 2>/dev/null; r.mask input=state@4km >/dev/null 2>/dev/null;\
	date=`g.gisenv MAPSET`;\
	r.stats -1 -n -x mTn,mTx,mPCP,NRF 2>/dev/null | sed -e "s/^/${MAPSET} /" | tr ' ' ',' > $@;\
	r.mask -r input=MASK >/dev/null 2>/dev/null;\
	g.region -d;

endif