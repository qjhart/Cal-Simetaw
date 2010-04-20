#! /usr/bin/make -f 
ifndef configure.mk
include configure.mk
endif

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




