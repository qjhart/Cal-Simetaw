#! /usr/bin/make -f 

ifndef configure.mk
include configure.mk
endif

ifndef monthly.mk
include monthly.mk
endif

ifndef daily.mk
include daily.mk
endif

ifndef 4km.mk
include 4km.mk
endif
