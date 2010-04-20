\set ON_ERROR_STOP 1
BEGIN;
drop schema if exists "4km_byrow" cascade;
create schema "4km_byrow";
set search_path="4km_byrow",public;

create table pixels (
x integer,
y integer,
east integer,
north integer,
longitude float,
latitude float,
primary key(x,y)
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

create index prism_xy on prism(x,y);
create index prism_year on prism(year);
create index prism_month on prism(month);

create table daily (
x integer,
y integer,
ymd date,
year integer check (year >0),
month integer check (month >=1 and month<=12),
day integer check (day <=31),
doy integer check (doy<=366),
Tx float,
Tn float,
PCP float,
ETo float,
RF boolean,
unique(x,y,ymd),
foreign key (x,y) references pixels (x,y)
);

-- In sub tables
-- create index daily_xy on daily(x,y);
-- create index daily_ymd on daily(ymd);
-- create index daily_year on daily(year);
-- create index daily_month on daily(month);


CREATE OR REPLACE FUNCTION daily_insert_trigger()
RETURNS TRIGGER AS $$
BEGIN
CASE NEW.y
WHEN 000 THEN insert into daily_000 VALUES (NEW.*);
WHEN 001 THEN insert into daily_001 VALUES (NEW.*);
WHEN 002 THEN insert into daily_002 VALUES (NEW.*);
WHEN 003 THEN insert into daily_003 VALUES (NEW.*);
WHEN 004 THEN insert into daily_004 VALUES (NEW.*);
WHEN 005 THEN insert into daily_005 VALUES (NEW.*);
WHEN 006 THEN insert into daily_006 VALUES (NEW.*);
WHEN 007 THEN insert into daily_007 VALUES (NEW.*);
WHEN 008 THEN insert into daily_008 VALUES (NEW.*);
WHEN 009 THEN insert into daily_009 VALUES (NEW.*);
WHEN 010 THEN insert into daily_010 VALUES (NEW.*);
WHEN 011 THEN insert into daily_011 VALUES (NEW.*);
WHEN 012 THEN insert into daily_012 VALUES (NEW.*);
WHEN 013 THEN insert into daily_013 VALUES (NEW.*);
WHEN 014 THEN insert into daily_014 VALUES (NEW.*);
WHEN 015 THEN insert into daily_015 VALUES (NEW.*);
WHEN 016 THEN insert into daily_016 VALUES (NEW.*);
WHEN 017 THEN insert into daily_017 VALUES (NEW.*);
WHEN 018 THEN insert into daily_018 VALUES (NEW.*);
WHEN 019 THEN insert into daily_019 VALUES (NEW.*);
WHEN 020 THEN insert into daily_020 VALUES (NEW.*);
WHEN 021 THEN insert into daily_021 VALUES (NEW.*);
WHEN 022 THEN insert into daily_022 VALUES (NEW.*);
WHEN 023 THEN insert into daily_023 VALUES (NEW.*);
WHEN 024 THEN insert into daily_024 VALUES (NEW.*);
WHEN 025 THEN insert into daily_025 VALUES (NEW.*);
WHEN 026 THEN insert into daily_026 VALUES (NEW.*);
WHEN 027 THEN insert into daily_027 VALUES (NEW.*);
WHEN 028 THEN insert into daily_028 VALUES (NEW.*);
WHEN 029 THEN insert into daily_029 VALUES (NEW.*);
WHEN 030 THEN insert into daily_030 VALUES (NEW.*);
WHEN 031 THEN insert into daily_031 VALUES (NEW.*);
WHEN 032 THEN insert into daily_032 VALUES (NEW.*);
WHEN 033 THEN insert into daily_033 VALUES (NEW.*);
WHEN 034 THEN insert into daily_034 VALUES (NEW.*);
WHEN 035 THEN insert into daily_035 VALUES (NEW.*);
WHEN 036 THEN insert into daily_036 VALUES (NEW.*);
WHEN 037 THEN insert into daily_037 VALUES (NEW.*);
WHEN 038 THEN insert into daily_038 VALUES (NEW.*);
WHEN 039 THEN insert into daily_039 VALUES (NEW.*);
WHEN 040 THEN insert into daily_040 VALUES (NEW.*);
WHEN 041 THEN insert into daily_041 VALUES (NEW.*);
WHEN 042 THEN insert into daily_042 VALUES (NEW.*);
WHEN 043 THEN insert into daily_043 VALUES (NEW.*);
WHEN 044 THEN insert into daily_044 VALUES (NEW.*);
WHEN 045 THEN insert into daily_045 VALUES (NEW.*);
WHEN 046 THEN insert into daily_046 VALUES (NEW.*);
WHEN 047 THEN insert into daily_047 VALUES (NEW.*);
WHEN 048 THEN insert into daily_048 VALUES (NEW.*);
WHEN 049 THEN insert into daily_049 VALUES (NEW.*);
WHEN 050 THEN insert into daily_050 VALUES (NEW.*);
WHEN 051 THEN insert into daily_051 VALUES (NEW.*);
WHEN 052 THEN insert into daily_052 VALUES (NEW.*);
WHEN 053 THEN insert into daily_053 VALUES (NEW.*);
WHEN 054 THEN insert into daily_054 VALUES (NEW.*);
WHEN 055 THEN insert into daily_055 VALUES (NEW.*);
WHEN 056 THEN insert into daily_056 VALUES (NEW.*);
WHEN 057 THEN insert into daily_057 VALUES (NEW.*);
WHEN 058 THEN insert into daily_058 VALUES (NEW.*);
WHEN 059 THEN insert into daily_059 VALUES (NEW.*);
WHEN 060 THEN insert into daily_060 VALUES (NEW.*);
WHEN 061 THEN insert into daily_061 VALUES (NEW.*);
WHEN 062 THEN insert into daily_062 VALUES (NEW.*);
WHEN 063 THEN insert into daily_063 VALUES (NEW.*);
WHEN 064 THEN insert into daily_064 VALUES (NEW.*);
WHEN 065 THEN insert into daily_065 VALUES (NEW.*);
WHEN 066 THEN insert into daily_066 VALUES (NEW.*);
WHEN 067 THEN insert into daily_067 VALUES (NEW.*);
WHEN 068 THEN insert into daily_068 VALUES (NEW.*);
WHEN 069 THEN insert into daily_069 VALUES (NEW.*);
WHEN 070 THEN insert into daily_070 VALUES (NEW.*);
WHEN 071 THEN insert into daily_071 VALUES (NEW.*);
WHEN 072 THEN insert into daily_072 VALUES (NEW.*);
WHEN 073 THEN insert into daily_073 VALUES (NEW.*);
WHEN 074 THEN insert into daily_074 VALUES (NEW.*);
WHEN 075 THEN insert into daily_075 VALUES (NEW.*);
WHEN 076 THEN insert into daily_076 VALUES (NEW.*);
WHEN 077 THEN insert into daily_077 VALUES (NEW.*);
WHEN 078 THEN insert into daily_078 VALUES (NEW.*);
WHEN 079 THEN insert into daily_079 VALUES (NEW.*);
WHEN 080 THEN insert into daily_080 VALUES (NEW.*);
WHEN 081 THEN insert into daily_081 VALUES (NEW.*);
WHEN 082 THEN insert into daily_082 VALUES (NEW.*);
WHEN 083 THEN insert into daily_083 VALUES (NEW.*);
WHEN 084 THEN insert into daily_084 VALUES (NEW.*);
WHEN 085 THEN insert into daily_085 VALUES (NEW.*);
WHEN 086 THEN insert into daily_086 VALUES (NEW.*);
WHEN 087 THEN insert into daily_087 VALUES (NEW.*);
WHEN 088 THEN insert into daily_088 VALUES (NEW.*);
WHEN 089 THEN insert into daily_089 VALUES (NEW.*);
WHEN 090 THEN insert into daily_090 VALUES (NEW.*);
WHEN 091 THEN insert into daily_091 VALUES (NEW.*);
WHEN 092 THEN insert into daily_092 VALUES (NEW.*);
WHEN 093 THEN insert into daily_093 VALUES (NEW.*);
WHEN 094 THEN insert into daily_094 VALUES (NEW.*);
WHEN 095 THEN insert into daily_095 VALUES (NEW.*);
WHEN 096 THEN insert into daily_096 VALUES (NEW.*);
WHEN 097 THEN insert into daily_097 VALUES (NEW.*);
WHEN 098 THEN insert into daily_098 VALUES (NEW.*);
WHEN 099 THEN insert into daily_099 VALUES (NEW.*);
ELSE insert into daily VALUES (NEW.*);
END CASE;
RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER insert_daily_trigger    
BEFORE INSERT ON daily FOR EACH ROW EXECUTE PROCEDURE daily_insert_trigger();

END;

