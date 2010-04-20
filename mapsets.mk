#! /usr/bin/make -f

ifndef configure.mk
include configure.mk
endif

#####################################################################
# MAPSET Making
#####################################################################
.PHONY: days years

years:
	${PG} -t -c "select distinct substr(day,1,4) from ncdc.weather where day::text ~ '$(or ${YYYY},.{4})-.{2}-.{2}'"

days:
	${PG} -t -c "select day from ncdc.weather where day::text ~ '$(or ${YYYY},.{4})-$(or ${MM},.{2})-$(or ${DD},.{2})'"

ifneq (${MM},)
loc:=$(patsubst %/,%,$(dir ${loc}))
endif 

y-mapsets:=$(patsubst %,${loc}/%,${years})
#m-mapsets:=$(foreach y,${years},$(patsubst %,${loc}/${y}/${y}-%,01 02 03 04 05 06 07 08 09 10 11 12))
m-mapsets:=$(foreach y,${years},$(patsubst %,${loc}/${y}/%,$(filter ${y}-%,${yms})))

info::
#	@echo ${m-mapsets}

.PHONY: mapsets
mapsets:${y-mapsets} ${m-mapsets}

${y-mapsets}:${loc}/%:
	g.mapset -c mapset=$*
	# as a location
	ln -s ../PERMANENT $@
	ln -s ../2km $@
	ln -s ../4km $@

#$(warning ${m-mapsets})

${m-mapsets}:${loc}/%:
	g.mapset gisdbase=${loc} location=$(subst /,,$(dir $*)) mapset=PERMANENT
	g.mapset -c gisdbase=${loc} location=$(subst /,,$(dir $*)) mapset=$(notdir $*)

#	cp ${loc}/2km/VAR $@

# ifeq (${DD},)
# mapset-dates:=$(shell for d in `seq 0 30`; do date --date="${YYYY}-${MM}-01 + $$d days" +%Y-%m-%d; done | grep ${YYYY}-${MM})
# mapsets:=$(patsubst %,${loc}/%,${mapset-dates})
# ${mapsets}:${loc}/%:
# 	g.mapset -c location=${YYYY} mapset=$*
# 	cp ${loc}/../2km/VAR $@
# endif #DD

