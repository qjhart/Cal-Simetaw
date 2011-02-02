#! /usr/bin/make -f 

INC:=/home/quinn/etosimetaw/bin
ifndef configure.mk
include ${INC}/configure.mk
endif

cfhs.mk:=1

.PHONY:INFO
INFO::
	echo cfhs

.PHONY:db
db::${db}/cfhs 

${db}/cfhs:
	${PG} -f cfhs/schema.sql
	touch $@

#create table new_factors as select east,north,m::decimal(6,2),m_0::decimal(6,2),cfhs from (select x,y,avg(1/m_0) as m_0,avg(m) as m from row_factors where season='YR' group by x,y) as rf join daily4km.pixels using (x,y) join daily4km.cfhs using (x,y) order by x,y;

