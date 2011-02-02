\set ON_ERROR_STOP 1
BEGIN;
drop schema if exists ncdctmp cascade;
create schema ncdctmp;
set search_path=ncdctmp,public;

create temp table dat (
DSET integer,
COOPID varchar(6),
WBNID integer,
CD integer,
ELEM varchar(4),
UN varchar(2),
YEARMO varchar(6),
DAHR01 varchar(4), DAY01 integer,M01 char,Q01 char,
DAHR02 varchar(4), DAY02 integer,M02 char,Q02 char,
DAHR03 varchar(4), DAY03 integer,M03 char,Q03 char,
DAHR04 varchar(4), DAY04 integer,M04 char,Q04 char,
DAHR05 varchar(4), DAY05 integer,M05 char,Q05 char,
DAHR06 varchar(4), DAY06 integer,M06 char,Q06 char,
DAHR07 varchar(4), DAY07 integer,M07 char,Q07 char,
DAHR08 varchar(4), DAY08 integer,M08 char,Q08 char,
DAHR09 varchar(4), DAY09 integer,M09 char,Q09 char,
DAHR10 varchar(4), DAY10 integer,M10 char,Q10 char,
DAHR11 varchar(4), DAY11 integer,M11 char,Q11 char,
DAHR12 varchar(4), DAY12 integer,M12 char,Q12 char,
DAHR13 varchar(4), DAY13 integer,M13 char,Q13 char,
DAHR14 varchar(4), DAY14 integer,M14 char,Q14 char,
DAHR15 varchar(4), DAY15 integer,M15 char,Q15 char,
DAHR16 varchar(4), DAY16 integer,M16 char,Q16 char,
DAHR17 varchar(4), DAY17 integer,M17 char,Q17 char,
DAHR18 varchar(4), DAY18 integer,M18 char,Q18 char,
DAHR19 varchar(4), DAY19 integer,M19 char,Q19 char,
DAHR20 varchar(4), DAY20 integer,M20 char,Q20 char,
DAHR21 varchar(4), DAY21 integer,M21 char,Q21 char,
DAHR22 varchar(4), DAY22 integer,M22 char,Q22 char,
DAHR23 varchar(4), DAY23 integer,M23 char,Q23 char,
DAHR24 varchar(4), DAY24 integer,M24 char,Q24 char,
DAHR25 varchar(4), DAY25 integer,M25 char,Q25 char,
DAHR26 varchar(4), DAY26 integer,M26 char,Q26 char,
DAHR27 varchar(4), DAY27 integer,M27 char,Q27 char,
DAHR28 varchar(4), DAY28 integer,M28 char,Q28 char,
DAHR29 varchar(4), DAY29 integer,M29 char,Q29 char,
DAHR30 varchar(4), DAY30 integer,M30 char,Q30 char,
DAHR31 varchar(4), DAY31 integer,M31 char,Q31 char
);
create index dat_coopid_wbnid on dat(coopid,wbnid);

COPY dat FROM 'dat.txt' WITH CSV HEADER;

drop table if exists weather;
create table weather as select * from ncdc.weather limit 0;
create index weather_station_id on weather(station_id);

insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day01 as v, m01 as m,q01 as q,(yearmo||substring(dahr01 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m01 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day02 as v, m02 as m,q02 as q,(yearmo||substring(dahr02 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m02 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day03 as v, m03 as m,q03 as q,(yearmo||substring(dahr03 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m03 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day04 as v, m04 as m,q04 as q,(yearmo||substring(dahr04 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m04 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day05 as v, m05 as m,q05 as q,(yearmo||substring(dahr05 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m05 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day06 as v, m06 as m,q06 as q,(yearmo||substring(dahr06 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m06 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day07 as v, m07 as m,q07 as q,(yearmo||substring(dahr07 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m07 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day08 as v, m08 as m,q08 as q,(yearmo||substring(dahr08 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m08 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day09 as v, m09 as m,q09 as q,(yearmo||substring(dahr09 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m09 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day10 as v, m10 as m,q10 as q,(yearmo||substring(dahr10 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m10 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day11 as v, m11 as m,q11 as q,(yearmo||substring(dahr11 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m11 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day12 as v, m12 as m,q12 as q,(yearmo||substring(dahr12 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m12 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day13 as v, m13 as m,q13 as q,(yearmo||substring(dahr13 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m13 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day14 as v, m14 as m,q14 as q,(yearmo||substring(dahr14 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m14 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day15 as v, m15 as m,q15 as q,(yearmo||substring(dahr15 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m15 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day16 as v, m16 as m,q16 as q,(yearmo||substring(dahr16 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m16 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day17 as v, m17 as m,q17 as q,(yearmo||substring(dahr17 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m17 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day18 as v, m18 as m,q18 as q,(yearmo||substring(dahr18 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m18 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day19 as v, m19 as m,q19 as q,(yearmo||substring(dahr19 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m19 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day20 as v, m20 as m,q20 as q,(yearmo||substring(dahr20 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m20 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day21 as v, m21 as m,q21 as q,(yearmo||substring(dahr21 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m21 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day22 as v, m22 as m,q22 as q,(yearmo||substring(dahr22 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m22 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day23 as v, m23 as m,q23 as q,(yearmo||substring(dahr23 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m23 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day24 as v, m24 as m,q24 as q,(yearmo||substring(dahr24 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m24 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day25 as v, m25 as m,q25 as q,(yearmo||substring(dahr25 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m25 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day26 as v, m26 as m,q26 as q,(yearmo||substring(dahr26 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m26 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day27 as v, m27 as m,q27 as q,(yearmo||substring(dahr27 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m27 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day28 as v, m28 as m,q28 as q,(yearmo||substring(dahr28 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m28 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day29 as v, m29 as m,q29 as q,(yearmo||substring(dahr29 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m29 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day30 as v, m30 as m,q30 as q,(yearmo||substring(dahr30 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m30 != 'M';
insert into weather (station_id,dset,elem,un,v,m,q,day)
select station_id,dset,elem,trim(both ' ' from un) as un,day31 as v, m31 as m,q31 as q,(yearmo||substring(dahr31 from 1 for 2))::date from dat join ncdc.station s using (coopid,wbnid) where m31 != 'M';

delete from weather where v=99999;
delete from weather where elem='TMAX' and v>135;
delete from weather where elem='TMIN' and v>110;
delete from weather w 
using (select w1.station_id,w1.day 
       from weather w1 
       join weather w2 
       using (station_id,day) 
       where w1.elem='TMIN' 
       and w2.elem='TMAX' 
       and w2.v<w1.v) as del 
where w.station_id=del.station_id and w.day=del.day;

-- convert to metric units
update weather set v=5.0*(v-32)/9.0 where elem in ('TMIN','TMAX');
update weather set v=v*0.254 where elem in ('PRCP');
END;

BEGIN;
insert into ncdc.weather (station_id,day,dset,elem,un,v,m,q) 
select station_id,day,dset,elem,un,v,m,q from weather;


--truncate m_monthly_weather;
--insert into m_monthly_weather select * from monthly_weather;

END;

drop schema ncdctmp cascade;


