\set ON_ERROR_STOP 1
BEGIN;
drop schema if exists :dailySchema cascade;
create schema :dailySchema;
set search_path=:dailySchema,public;

create table daily (
x integer,
y integer,
ymd date,
year integer,
month integer,
day integer,
doy integer,
Tx float,
Tn float,
PCP float,
ETo float,
RF boolean
);

END;