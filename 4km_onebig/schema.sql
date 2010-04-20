\set ON_ERROR_STOP 1
BEGIN;
drop schema if exists "4km" cascade;
create schema "4km";
set search_path="4km",public;

create table pixels (
x integer,
y integer,
east integer,
north integer,
longitude float,
latitude float,
primary key(x,y)
);

create table cfhs (
x integer,
y integer,
cfhs float,
unique(x,y),
foreign key (x,y) references pixels (x,y)
);

create table prism (
x integer,
y integer,
year integer check (year >0),
month integer check (month >=1 and month<=12),
Tn float,
Tx float,
PCP float,
NRD integer check (NRD >= 0),
unique(x,y,year,month),
foreign key (x,y) references pixels (x,y)
);

create index prism_x on prism(x);
create index prism_y on prism(y);
create index prism_year on prism(year);
create index prism_month on prism(month);

create table daily (
x integer,
y integer,
ymd date,
year integer check (year >0),
month integer check (month >=1 and month<=12),
day integer check (day <=31),
doy integer check (doy<366),
Tx float,
Tn float,
PCP float,
ETo float,
RF boolean,
unique(x,y,ymd),
foreign key (x,y) references pixels (x,y)
);

create index daily_xy on daily(x,y);
--create index daily_y on daily(y);
create index daily_ymd on daily(ymd);
create index daily_year on daily(year);
create index daily_month on daily(month);

END;

