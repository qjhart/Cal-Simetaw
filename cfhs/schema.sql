\set ON_ERROR_STOP 1
BEGIN;
drop schema if exists cfhs cascade;
create schema cfhs;
set search_path=cfhs,public;

END;

create table seasons (
season varchar(8),
month integer
);  

copy seasons from STDIN with CSV HEADER;
season,month
OND,10
OND,11
OND,12
JFM,1
JFM,2
JFM,3
AMJ,4
AMJ,5
AMJ,6
JAS,7
JAS,8
JAS,9
YR,10
YR,11
YR,12
YR,1
YR,2
YR,3
YR,4
YR,5
YR,6
YR,7
YR,8
YR,9
\.


create table factors (
  x integer,
  y integer,
  season varchar(8),
  year integer,
  m float,
  b float,
  r2 float,
  m_0 float,
  r2_0 float,
  primary key(x,y)
);


CREATE OR REPLACE FUNCTION row_factor(this_row integer) RETURNS SETOF factors AS $$
DECLARE
dt varchar(32);
ct varchar(32);
rows text;
BEGIN
dt := 'daily4km.daily' || lpad(this_row::text,3,'0');
ct := 'cimis4km.cimis' || lpad(this_row::text,3,'0');

drop table if exists tmp_last_row_factor; 
rows := 'create temp table tmp_last_row_factor as 
 select x,y,season,year,
 regr_slope(c.et0,d.eto) as m,
 regr_intercept(c.et0,d.eto) as b, 
 regr_r2(c.et0,d.eto), 
 sum(c.et0*d.eto)/sum(c.et0*c.et0) as m_0,
 (sum(c.et0*d.eto))^2/(sum(c.et0*c.et0)*sum(d.eto*d.eto)) as r2_0 
from ' || dt || ' d 
join ' || ct || ' c using (x,y,year,month,ymd) 
join cfhs.seasons using (month) 
group by season,year,x,y 
order by x,y,season;';

RAISE NOTICE '%', rows;

EXECUTE rows;

RETURN QUERY select * from tmp_last_row_factor;

drop table if exists tmp_last_row_factor;
END;
$$ LANGUAGE PLPGSQL;