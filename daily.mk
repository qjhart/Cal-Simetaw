#! /usr/bin/make -f

# This setup was for a multi-day setup.  I'm not sure that's the best
# idea, so some of this is going in the daily.mk file as well.  (one
# mapset only
#yr=1948; for d in `seq 0 3285`; do m=`date --date="${yr}-01-01 + $d days" --rfc-3339=date`; y=${m%%-*};  g.mapset location=$y mapset=$m; time ~/etosimetaw/bin/daily.mk ETo RF; done

INC:=/home/quinn/etosimetaw/bin

ifndef configure.mk
include ${INC}/configure.mk
endif

#####################################################################
# Daily Mapset files
#####################################################################
tension:=10
zmult:=1
smooth:=0.05

#v.surf.rst:=v.surf.rst maskmap=state@4km tension=${tension} \
#            zmult=${zmult} smooth=${smooth}
v.surf.rst:=v.surf.rst tension=${tension} zmult=${zmult} smooth=${smooth}

.PHONY: delta

ncdc_name_Tx:=TMAX
ncdc_name_Tn:=TMIN
ncdc_name_PCP:=PRCP

define set_vect
g.remove vect=d$1;\
g.region -d;g.region rast=state@4km; \
db.connect driver=sqlite database='$$$$GISDBASE/$$$$LOCATION_NAME/$$$$MAPSET/sqlite.db'; 
endef

define ncdc

.PHONY: $1
$1::${vect}/$1

${vect}/$1:
	${v.in.ogr} layer=ncdc.weather \
	where="day='${MAPSET}' and elem='$${ncdc_name_$1}' and m NOT IN ('E','M','S','(');" \
	output=$1 >/dev/null 2>/dev/null

.PHONY: delta
delta::d$1
.PHONY: d$1
d$1:${rast}/d$1

${vect}/d$1:
	$(call set_vect,$1)
	[[ -d ${map}/site_lists ]] || mkdir ${map}/site_lists; \
	${PG-SITE} -c "select x(centroid),y(centroid),'#'||station_id||' %'||dv from ncdc.m_delta_weather where day='${MAPSET}' and elem='$${ncdc_name_$1}'" > ${map}/site_lists/d$1;\
	v.in.sites input=d$1 output=d$1; \
	g.remove site=d$1

# v.in.ogr is about 7 times slower then converting to a sites file as above
# ${vect}/d$1:
# 	$(call set_vect,$1)
# 	${v.in.ogr} layer=ncdc.m_delta_weather \
#         where="day='${MAPSET}' and elem='$${ncdc_name_$1}'" \
# 	output=d$1 >/dev/null 2>/dev/null

${rast}/d$1: ${vect}/d$1
	${NOMASK}; \
	${v.surf.rst} input=d$1 zcolumn=flt1 elev=d$1 >/dev/null 2>/dev/null

endef

define mult-day
.PHONY: day
$1::${rast}/$1
day: ${rast}/$1

${rast}/$1: ${rast}/d$1 ${monthly-rast}/m$1
	${NOMASK};
	r.mapcalc '$1=if(d$1<0.0,0.0,d$1)*"m$1@${monthly-mapset}"' >/dev/null 2>/dev/null

endef

define add-day
.PHONY: day
$1::${rast}/$1
day: ${rast}/$1

${rast}/$1: ${rast}/d$1 ${monthly-rast}/m$1
	${NOMASK}; \
	r.mapcalc '$1=d$1+"m$1@${monthly-mapset}"' >/dev/null 2>/dev/null

endef

define daily

.PHONY:sretr
sretr:${rast}/srha
${rast}/srha:
	@${NOMASK};\
	pi=3.14159265;\
	julian=`date --date="${MAPSET}" +%j`;\
	jul_deg="(360*($$$$julian/365.0))";\
	dr="(1.0+0.033*cos($$$$jul_deg))";\
	declination="180.0/$$$$pi*0.409*sin($$$$jul_deg-79.64)";\
	r.mapcalc "srha=acos(-tan(latitude_deg@4km)*tan($$$$declination))"; 

.PHONY:Ra
Ra:${rast}/Ra
${rast}/Ra:${rast}/srha
	@${NOMASK};\
	pi=3.14159265; Gsc=0.082; \
	julian=`date --date="${MAPSET}" +%j`;\
	jul_deg="(360*($$$$julian/365.0))";\
	dr="(1.0+0.033*cos($$$$jul_deg))";\
	declination="180.0/$$$$pi*0.409*sin($$$$jul_deg-79.64)";\
	r.mapcalc "Ra=(24.0*60.0/$$$$pi)*$$$$Gsc*$$$$dr*((srha*$$$$pi/180.0)*sin($$$$declination)*sin(latitude_deg@4km)+cos(latitude_deg@4km)*cos($$$$declination)*sin(srha))";

.PHONY:Tm
Tm:$(rast)/Tm
$(rast)/Tm: $(rast)/Tx $(rast)/Tn
	@${NOMASK}; \
	r.mapcalc "Tm=(Tx+Tn)/2";

.PHONY:ETh
ETh:$(rast)/ETh
$(rast)/ETh: $(rast)/Tm $(rast)/Tx $(rast)/Tn $(rast)/Ra
	@${NOMASK};\
	r.mapcalc "ETh=if(Tx<Tn,0,0.408*(0.0023*Ra*(Tm+17.8))*(sqrt(Tx-Tn)))" 2>/dev/null;

.PHONY:ETo
ETo:$(rast)/ETo
$(rast)/ETo:$(rast)/ETh 
	@${NOMASK};\
	r.mapcalc "ETo=ETh*cfhs@4km" 2>/dev/null;\

.PHONY:RD
RD:$(rast)/RD
$(rast)/RD: $(rast)/ETo $(rast)/PCP
	@${NOMASK};\
	r.mapcalc "RD=if(ETo>PCP,0,1)";

.PHONY:RF
RF:$(rast)/RF
$(rast)/RF: $(rast)/ETo $(rast)/PCP
	@${NOMASK}; \
	r.mapcalc "RF=if(isnull(ETo),if(PCP>0,1,0),if(ETo>PCP,0,1))" >/dev/null 2>/dev/null;

endef

ifeq (${DD},)
  $(error ${MAPSET} is not a daily MAPSET)
endif

$(eval $(call daily))
$(foreach p,Tx Tn PCP,$(eval $(call ncdc,$(p))))
$(foreach p,PCP,$(eval $(call mult-day,$(p))))
$(foreach p,Tx Tn,$(eval $(call add-day,$(p))))

