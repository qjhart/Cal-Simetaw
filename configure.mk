#! /usr/bin/make -f
configure.mk:=1

start_year:=1920
end_year:=2010
mid_years:= $(shell seq `echo ${start_year}+1 | bc` `echo ${end_year}-1 | bc`)
years:=${start_year} ${mid_years} ${end_year}

months:=10 11 12 01 02 03 04 05 06 07 08 09

yms:=$(patsubst %,${start_year}-%,10 11 12) \
$(foreach y,${mid_years},$(patsubst %,$y-%,01 02 03 04 05 06 07 08 09 10 11 12)) \
$(patsubst %,${end_year}-%,01 02 03 04 05 06 07 08 09)

#include days.mk

y-yms:=$(foreach y,${yms},$(firstword $(subst -, ,$y))/$y)
y-d:=$(foreach d,${days},$(firstword $(subst -, ,$d))/$d)

SHELL:=/bin/bash

# Filesystem
fs-root:=/home/quinn/etosimetaw
out:=${fs-root}/output
down:=${fs-root}/data

# Input Postgres DB
db:=/home/quinn/etosimetaw/db
database:=etosimetaw
PG:=psql --cluster 8.4/eto -d ${database}
PG-CSV:= ${PG} -A -F',' --pset footer
PG-LIST:=${PG} -A -R' ' -t 
PG-SITE:= ${PG} -A -F'|' -t
#PG:= psql -d ${db} -h casil.ucdavis.edu -U qjhart -p 5433


#v.in.ogr:=v.in.ogr -e dsn="PG:dbname=${db} host=casil.ucdavis.edu port=5433 user=qjhart"
v.in.ogr:=v.in.ogr -e dsn="PG:dbname=${database} port=5433"

# Grass specific functions
define grass_or_die
$(if ifndef GISRC,$(error Must be running in GRASS))
endef

ifdef GISRC

#eto-gisdbase:=/home/quinn/gdb/etosimetaw

GISDBASE:=$(shell g.gisenv get=GISDBASE)
LOCATION_NAME:=$(shell g.gisenv get=LOCATION_NAME)
MAPSET:=$(shell g.gisenv get=MAPSET)

YYYY:=$(word 2,$(subst -, ,f-${MAPSET}))
MM:=$(word 3,$(subst -, ,f-${MAPSET}))
DD:=$(word 4,$(subst -, ,f-${MAPSET}))

#$(warning YYYY=${YYYY} MM=${MM} DD=${DD})

date:=${MAPSET}

# Generic vol.rst parmeters
WIND3:=$(loc)/$(MAPSET)/WIND3
DEFAULT_WIND3:=$(loc)/PERMANENT/WIND3

# Shortcut Directories
gdb:=${GISDBASE}
loc:=$(GISDBASE)/$(LOCATION_NAME)
map:=$(GISDBASE)/$(LOCATION_NAME)/${MAPSET}
rast:=$(loc)/$(MAPSET)/cellhd
vect:=$(loc)/$(MAPSET)/vector
etc:=$(loc)/$(MAPSET)/etc

else 

GISDBASE:=/home/groups/etosimetaw/gdb
gdb:=${GISDBASE}

endif

##############################################################################
# MASK defines
##############################################################################
#define MASK
#g.region rast=state@4km; (g.findfile element=cellhd file=MASK || g.copy rast=sta#te@4km,MASK) > /dev/null
#endef

define MASK
g.region rast=state@4km; r.mask -o input=state@4km;
endef

define NOMASK
g.region rast=state@4km; r.mask -r
endef

define NOMASK-OLD
g.region rast=state@4km; if ( g.findfile element=cellhd file=MASK > /dev/null); then g.remove MASK &>/dev/null; fi
endef

####################################
# Mapset specific
####################################

ifeq (${MAPSET},${db})

else # is YEAR

ifeq (${MM},)

else

ifeq (${DD},)

is_monthly=${MAPSET}

else

is_daily:=${MAPSET}
monthly-mapset:=${YYYY}-${MM}
monthly-rast:=$(loc)/$(monthly-mapset)/cellhd


endif #DD

endif #MM

endif # Year or no


info::
	echo ${y-d}

days.mk:
	echo days:=$$(for ym in ${yms}; do for dom in `seq 0 31`; do date --date="$${ym}-01 + $${dom} days" +%Y-%m-%d; done ; done | sort -u ) > $@

yms:
	@echo ${yms}
