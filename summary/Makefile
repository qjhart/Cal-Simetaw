#! /usr/bin/make -f 

INC:=/home/quinn/etosimetaw/bin
ifndef configure.mk
include ${INC}/configure.mk
endif

schema:=summary

daily-rowtables:=$(patsubst %,${db}/${schema}.daily%,${rows})
daily-rowtables-data:=$(patsubst %,${db}/${schema}.daily%.data,${rows})

db:: ${db}/${schema}.daily

${db}/${schema}:${db}/%:
	${PG} -c "drop schema if exists $* cascade;create schema $*;"
	touch $@

${db}/${schema}.daily:${db}/${schema}.daily_only ${daily-rowtables}
	touch $@

${db}/${schema}.daily_only:${db}/${schema}
	${PG} -f daily.sql
	touch $@

${daily-rowtables}:${db}/${schema}.daily%:${db}/${schema}
	${PG} --variable=r=$* -f add_daily.sql
	touch $@

.PHONY:data
data:${daily-rowtables-data}
daily-rowtables-data:${daily-rowtables-data}
${daily-rowtables-data}:${db}/${schema}.daily%.data:${db}/${schema}.daily_only
	${PG} --variable=r=$* -f add_daily_data.sql


