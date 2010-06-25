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
# Monthly Mapset files
#####################################################################
define prism

.PHONY: prism
prism::m$1
.PHONY: m$1
m$1:${rast}/m$1

${rast}/m$1: ${prism-$1}
	r.in.arc input=${prism-$1} output=m$1 type=FCELL mult=0.01
endef

prism-dir:=${fs-root}/PRISM
prism-Tn:=${prism-dir}/tmin/us_tmin_${YYYY}.${MM}_teal83_ca.asc
prism-Tx:=${prism-dir}/tmax/us_tmax_${YYYY}.${MM}_teal83_ca.asc
prism-PCP:=${prism-dir}/ppt/us_ppt_${YYYY}.${MM}_teal83_ca.asc

$(foreach p,Tx Tn PCP,$(eval $(call prism,$(p))))

#m-mapsets:=$(foreach y,${years},$(patsubst %,${loc}/${y}/%,$(filter ${y}-%,${yms})))




