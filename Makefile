#! /usr/bin/make -f 

INC:=/home/quinn/etosimetaw/bin

ifndef configure.mk
include ${INC}/configure.mk
endif

ifndef monthly.mk
include ${INC}/monthly.mk
endif

ifndef daily.mk
include ${INC}/daily.mk
endif

ifndef daily4km.mk
include ${INC}/daily4km.mk
endif


