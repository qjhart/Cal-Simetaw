#! /usr/bin/make -f

INC:=/home/quinn/etosimetaw/bin
ifndef configure.mk
include ${INC}/configure.mk
endif

ifdef is_monthly

mapsets:=$(shell g.mapsets -l | tr ' ' "\n" | grep ${MAPSET}-..)

.PHONY: NRF
NRF:$(rast)/NRF

${rast}/NRF:${rast}/N%:
	${NOMASK}
	r.mapcalc '$(notdir $@)=$(patsubst %,"$*@%"+,${mapsets})0'

endif