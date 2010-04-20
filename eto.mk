#! /usr/bin/make -f 

# This setup was for a multi-day setup.  I'm not sure that's the best
# idea, so some of this is going in the daily.mk file as well.  (one
# mapset only

ifndef configure.mk
include configure.mk
endif


##############################################################################
# MASK defines
##############################################################################
define MASK
	@(g.findfile element=cellhd file=MASK || g.copy rast=state@2km,MASK) > /dev/null
endef

define NOMASK
	@if ( g.findfile element=cellhd file=MASK > /dev/null); then g.remove MASK &>/dev/null; fi
endef

#####################################################################
# Daily Mapset files
#####################################################################
tension:=10
zmult:=1
smooth:=0.05

define ncdc

.PHONY: $1
$1::${gdb}/$$(firstword $$(subst -, ,$2))/$2/vector/$1:

${gdb}/$$(firstword $$(subst -, ,$2))/$2/vector/$1:y=$$(firstword $$(subst -, ,$2)
${gdb}/$$(firstword $$(subst -, ,$2))/$2/vector/$1:
	g.mapset mapset=$2 location=$y
	${v.in.ogr} layer=ncdc.weather \
	where="date='$2' and type='$1' and m NOT IN ('E','M','S','(');" \
	output=$1 >/dev/null 2>/dev/null

d$1::${gdb}/$$(firstword $$(subst -, ,$2))/$2/rast/d$1:

${gdb}/$$(firstword $$(subst -, ,$2))/$2/vector/d$1:y=$(firstword $(subst -, ,$2)
${gdb}/$$(firstword $$(subst -, ,$2))/$2/vector/d$1:
	g.mapset mapset=$2 location=$y
	${v.in.ogr} layer=ncdc.delta_weather \
	where="date='$2' and type='$1' and m NOT IN ('E','M','S','(');" \
	doutput=$1 >/dev/null 2>/dev/null

#.PHONY: delta
#delta::d$1
#.PHONY: d$1
#d$1:${rast}/d$1

#${rast}/d$1: ${vect}/$1
#	${v.surf.rst} input=$1 zcolumn=$1 elev=d$1 >/dev/null 2>/dev/null

endef

define mult-day
.PHONY: day
$1::${rast}/$1
day: ${rast}/$1

${rast}/$1: ${rast}/d$1 ${monthly-rast}/m$1
	g.region -d; \
	r.mapcalc '$1=if(d$1<0.0,0.0,d$1)*"m$1@${monthly-mapset}"' >/dev/null 2>/dev/null

endef

define add-day
.PHONY: day
$1::${rast}/$1
day: ${rast}/$1

${rast}/$1: ${rast}/d$1 ${monthly-rast}/m$1
	g.region -d; \
	r.mapcalc '$1=d$1+"m$1@${monthly-mapset}"' >/dev/null 2>/dev/null

endef

define daily

.PHONY:TnTxPCPEToRF.csv
TnTxPCPEToRF.csv:${etc}/TnTxPCPEToRF.csv
${etc}/TnTxPCPEToRF.csv: ${rast}/Tn ${rast}/Tx ${rast}/PCP ${rast}/ETo ${rast}/RF
	@[[ -d $$(dir $$@) ]]  || mkdir $$(dir $$@);\
	g.region rast=state@4km;\
	r.mask -r input=MASK >/dev/null 2>/dev/null; r.mask input=interior_mask@4km >/dev/null 2>/dev/null;\
	date=`g.gisenv MAPSET`;\
	r.stats -1 -n -x Tn,Tx,PCP,ETo,RF 2>/dev/null | sed -e "s/^/$$$$date /" | tr ' ' ',' > $$@;\
	r.mask -r input=MASK >/dev/null 2>/dev/null;\
	g.region -d;

.PHONY:sretr
sretr:${rast}/srha
${rast}/srha:
	pi=3.14159265;\
	julian=`date --date="${MAPSET}" +%j`;\
	jul_deg="(360*($$$$julian/365.0))";\
	dr="(1.0+0.033*cos($$$$jul_deg))";\
	declination="360.0/$$$$pi*0.409*sin($$$$jul_deg-79.64)";\
	r.mapcalc "srha=acos(-tan(latitude_deg@2km)*tan($$$$declination))"; 

.PHONY:Ra
Ra:${rast}/Ra
${rast}/Ra:${rast}/srha
	pi=3.14159265; Gsc=0.082; \
	julian=`date --date="${MAPSET}" +%j`;\
	jul_rad="(360*($$$$julian/365.0))";\
	dr="(1.0+0.033*cos($$$$jul_rad))";\
	declination="360.0/$$$$pi*0.409*sin($$$$jul_rad-79.64)";\
	r.mapcalc "Ra=(24.0*60.0/$$$$pi)*$$$$Gsc*$$$$dr*((srha*$$$$pi/180.0)*sin($$$$declination)*sin(latitude_deg@2km*$$$$pi/180.0)+cos(latitude_deg@2km*$$$$pi/180.0)*cos($$$$declination)*sin(srha))";\

.PHONY:Tm
Tm:$(rast)/Tm
$(rast)/Tm: $(rast)/Tx $(rast)/Tn
	r.mapcalc "Tm=(Tx+Tn)/2";

.PHONY:ETh
ETh:$(rast)/ETh
$(rast)/ETh: $(rast)/Tm $(rast)/Tx $(rast)/Tn $(rast)/Ra
	@r.mapcalc "ETh=if(Tx<Tn,0,0.408*(0.0023*Ra*(Tm+17.8))*(sqrt(Tx-Tn)))" 2>/dev/null;

.PHONY:ETo
ETo:$(rast)/ETo
$(rast)/ETo:$(rast)/ETh 
	@r.mapcalc "ETo=ETh*cfhs@2km" 2>/dev/null;\

.PHONY:RD
RD:$(rast)/RD
$(rast)/RD: $(rast)/ETo $(rast)/PCP
	r.mapcalc "RD=if(ETo>PCP,0,1)";

.PHONY:RF
RF:$(rast)/RF
$(rast)/RF: $(rast)/ETo $(rast)/PCP
	@r.mapcalc "RF=if(isnull(ETo),if(PCP>0,1,0),if(ETo>PCP,0,1))" >/dev/null 2>/dev/null;

endef

ifeq (${DD},)
  $(error ${MAPSET} is not a daily MAPSET)
endif

$(eval $(call daily))
$(foreach p,Tx Tn PCP,$(eval $(call ncdc,$(p))))
$(foreach p,PCP,$(eval $(call mult-day,$(p))))
$(foreach p,Tx Tn,$(eval $(call add-day,$(p))))

