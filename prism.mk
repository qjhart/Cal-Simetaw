#! /usr/bin/make -f 
ifndef configure.mk
include configure.mk
endif

#####################################################################
# Download all files:
#####################################################################
define download

.PHONY: download
download::${down}/prism.oregonstate.edu/pub/prism/us/grids/$1/$2

${down}/prism.oregonstate.edu/pub/prism/us/grids/$1/$2:
	cd ${down};\
	wget -m ftp://prism.oregonstate.edu/pub/prism/us/grids/$1/$2

endef
$(foreach v,tmin tmax ppt,$(foreach d,1920-1929 1930-1939 1940-1949 1950-1959 1960-1969 1970-1979 1980-1989 1990-1999 2000-2009,$(eval $(call download,$v,$d))))


#####################################################################
# Monthly Mapset files - US data
# http://prism.oregonstate.edu/docs/meta/ppt_realtime_monthly.htm gives
# info on the projection information, etc.
# Ran with
#for m in `make -f prism.mk yms`; do g.mapset -c $m; make -f prism.mk prism-us; done
#####################################################################
.PHONY: prism-us

define prism-us

prism-us::${rast}/m$1
#.PHONY: m$1
#m$1:${rast}/m$1

${rast}/m$1: ${prism-$1}
	f=`mktemp`; \
	zcat ${prism-$1} > $$$$f ; \
	r.in.arc input=$$$$f output=m$1 type=FCELL mult=0.01; \
	rm $$$$f;
endef

YYY:=$(shell echo ${YYYY} | cut -b 1-3)
dec:=${YYY}0-${YYY}9
prism-dir:=${fs-root}/data/prism.oregonstate.edu/pub/prism/us/grids
prism-Tn:=${prism-dir}/tmin/${dec}/us_tmin_${YYYY}.${MM}.gz
prism-Tx:=${prism-dir}/tmax/${dec}/us_tmax_${YYYY}.${MM}.gz
prism-PCP:=${prism-dir}/ppt/${dec}/us_ppt_${YYYY}.${MM}.gz

#$(foreach p,Tx Tn PCP,$(eval $(call prism-us,$(p))))
$(warning ${LOCATION_NAME})

#####################################################################
# Monthly Mapset files
#for m in `make -f prism.mk yms`; do y=${m%-*}; g.mapset location=$y mapset=$m; for r in Tn Tx PCP; do if (g.findfile element=cellhd file=m${r} > /dev/null); then g.rename rast=m${r},m${r}-old; fi; done ; done
#####################################################################
.PHONY: prism
define prism

prism::m$1
.PHONY: m$1
m$1:${rast}/m$1

${rast}/m$1: ${gdb}/prism-us/${MAPSET}/cellhd/m$1
	r.mask -r; g.region -d; g.region rast=state@4km;
	r.proj --o input=m$1 location=prism-us method=nearest
endef

$(foreach p,Tx Tn PCP,$(eval $(call prism,$(p))))





