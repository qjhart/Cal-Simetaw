#! /usr/bin/make -f

ifndef configure.mk
include configure.mk
endif

ifneq (${MAPSET},${db})
$(error NOT in proper MAPSET ${MAPSET} != ${db})
endif 

mapsets:=$(shell ${PG} -t -q -A -c "select distinct extract(year from day) as year from ncdc.weather order by year" | sed -e 's|^\s*|${map}/|')

${mapsets}:${map}/%:
	mkdir -p $@
	# as a location
	ln -s ../PERMANENT $@
	ln -s ../2km $@
	# These are as a mapset
	cp ${map}/template/WIND $@
	cp ${map}/template/VAR $@

.PHONY:mapsets
mapsets: ${mapsets}
