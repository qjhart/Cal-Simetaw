\set ON_ERROR_STOP 1
BEGIN;
drop schema if exists ncdc cascade;
create schema ncdc;
set search_path=ncdc,public;

create table station (
station_id serial primary key,
coopid integer,
wbnid integer,
name varchar(30),
country varchar(30),
state varchar(2),
county varchar(30),
cd varchar(2),
latitude float,
longitude float,
elevation float,
unique(coopid,wbnid)
);

select AddGeometryColumn('ncdc','station','centroid',3310,'POINT',2);
create index station_centroid_gist 
on ncdc.station using gist(centroid gist_geometry_ops);

create table weather (
station_id integer,
day date,
dset varchar(4),
elem varchar(4),
un varchar(2),
v float,
m char,
q char,
unique(station_id,day,elem)
);
create index weather_station_id on ncdc.weather(station_id);
create index weather_day on ncdc.weather(day);

create view monthly_weather as
select station_id,year,month,Tn,Tx,PCP,
       Tn_stddev,Tx_stddev,PCP_count,PCP_stddev 
from (select 
station_id,
extract(year from day) as year,extract(month from day) as month,
avg(v) as Tn,stddev(v) as Tn_stddev
from weather
where elem='TMIN' and m NOT IN ('E','M','S','(')
group by station_id,extract(year from day),extract(month from day)
) as tmin 
join (select 
station_id,
extract(year from day) as year,extract(month from day) as month,
avg(v) as Tx,stddev(v) as Tx_stddev
from weather
where elem='TMAX' and m NOT IN ('E','M','S','(')
group by station_id,extract(year from day),extract(month from day)
) as tmax 
using(station_id,year,month)
join (select 
station_id,
extract(year from day) as year,extract(month from day) as month,
sum(v) as PCP,stddev(v) as PCP_stddev,count(*) as PCP_count
from weather
where elem='PRCP' and m NOT IN ('E','M','S','(') 
group by station_id,extract(year from day),extract(month from day)
) as prcp
using (station_id,year,month);

create table m_monthly_weather as select * from monthly_weather limit 0;

create table prism (
station_id integer,
year integer,
month integer,
Tn float,
Tx float,
PCP float
);

-- create view average_station_differences as 
-- select station_id,avg(((w.Tn-32.0)*(5.0/9.0))-P.Tn) as dTn,
--  avg(((w.Tx-32.0)*(5.0/9.0))-p.Tx) as dTx,
--  avg((w.PCP*25.4/100.0)-p.PCP) as dPCP 
-- from prism p 
-- join m_monthly_weather w 
-- using (station_id,year,month) 
-- group by station_id;

create or replace view delta_weather as 
select w.station_id,day,elem,v-p.Tn as dv
from ncdc.weather w join ncdc.prism p
on (w.station_id=p.station_id 
    and extract(year from day)=p.year 
    and extract(month from day)=p.month)
where elem='TMIN' and m NOT IN ('E','M','S','(') 
union
select w.station_id,day,elem,v-p.Tx 
from ncdc.weather w join ncdc.prism p
on (w.station_id=p.station_id 
    and extract(year from day)=p.year 
    and extract(month from day)=p.month)
where elem='TMAX' and m NOT IN ('E','M','S','(') 
union
select w.station_id,day,elem,case when m.PCP=0 then 0 else (v/m.PCP) end
from 
( select station_id,day,elem,v,
         extract(year from day) as year,
         extract(month from day) as month 
  from ncdc.weather where elem='PRCP' and m NOT IN ('E','M','S','(')) as w
join ncdc.prism p
using (station_id,year,month)
join m_monthly_weather m 
using (station_id,year,month);


create table mflags (
       flag char,
       description text
);

COPY mflags (flag,description) FROM STDIN WITH DELIMITER ':';
A:Accumulated amount since last measurement.
B:Accumulated amount includes estimated values (since last measurement).
E:Estimated (see Table "O" for estimating method).
J:Value has been manually validated.
M:the data value is missing. In this case, the sign of the meteorological value is assigned "-" and the value of the meteorological element is assigned "99999".
S:Included in a subsequent value. (data value = "00000" OR  "99999").
T:Trace (data value = 00000 for a trace).
(:Expert system edited value, not validated.
):Expert system approved edited value.
\N:Flag not needed.
\.

create table qflags (
       flag char,
       description text
);

COPY qflags (flag,description) FROM STDIN WITH DELIMITER ':';
0:Valid data element.
1:Valid data element (from "unknown" source, pre-1982).
2:Invalid data element (subsequent value replaces original value).
3:Invalid data element (no replacement value follows).
4:Validity unknown (not checked).
5:Original non-numeric data value has been replaced by its deciphered numeric value.
A:Substituted TOBS for TMAX or TMIN
B:Time shifted value
C:Precipitation estimated from snowfall
D:Transposed digits
E:Changed units
F:Adjusted TMAX or TMIN by a multiple of + or -10 degrees
G:Changed algebraic sign
H:Moved decimal point
I:Rescaling other than F, G, or H
J:Subjectively derived value
K:Extracted from an accumulated value
L:Switched TMAX and/or TMIN
M:Switched TOBS with TMAX or TMIN
N:Substitution of "3 nearest station mean"
O:Switched snow and precipitation data value
P:Added snowfall to snow depth
Q:Switched snowfall and snow depth
R:Precipitation not reported; estimated as "O"
S:Manually edited value could be derived by any of the procedures noted by Flags A-R.
T:Failed internal consistency check
U:Failed areal consistency check (beginning Oct. 1992)
V:Replacement value based on Temp Val QC process (beginning Feb. 2006)
\.

create table units (
       unit varchar(2) primary key,
       description text
);

COPY units (unit,description) from STDIN WITH DELIMITER ':';
C:Whole degrees Celsius
CM:Centimeters
D:Whole Fahrenheit degree days
DT:Wind direction in tens of degrees
DW:Wind direction in whole degrees
F:Whole degrees Fahrenheit
FN:Feet and tenths
FT:Whole feet
HF:Hundreds of feet
HI:Hundredths of inches
HM:Hundredths of miles
HR:Time in hours and minutes
HT:Hundredths of inches but observation was only made to tenths
I:Whole inches
IH:Hundredths of inches of mercury
IT:Thousandths of inches of mercury
KD:Knots and direction in tens of degrees
KS:Knots and direction in 16 pt. code
M:Whole miles
MD:MPH and direction in tens of degrees
ME:Whole meters
MH:Miles per hour
MM:Millimeters
MN:Minutes
MS:MPH and direction in 16 pt. code
MT:Tenths of millibars
NA:No units applicable (none-dimensional)
N1:No units applicable - element to tenths
N2:No units applicable - element to hundredths
OS:Oktas of sky cover
P:Whole percent
TC:Tenths of degree Celsius
TD:Tenths of Fahrenheit degree days
TF:Tenths of degrees Fahrenheit
TH:Tenths of hours
TI:Tenths of inches
TK:Tenths of knots
TL:Tenths of miles per hour
TM:Tenths of millimeters
TP:Tenths of percent
TS:Tenths of sky cover
\.

END;

