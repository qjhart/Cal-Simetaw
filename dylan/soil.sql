\set ON_ERROR_STOP 1
BEGIN;
set search_path=dylan, "4km",public;

drop table if exists statsgo;
create table statsgo (
x integer,
y integer,
AWC float,
SDx float,
primary key(x,y)
);

drop table if exists ssurgo;
create table ssurgo (
x integer,
y integer,
AWC float,
SDx float,
primary key(x,y)
);

drop table if exists combined;
create table combined (
x integer,
y integer,
AWC float,
SDx float,
primary key(x,y)
);

drop table if exists soil;
create table soil (
x integer,
y integer,
AWC float,
SDx float,
primary key(x,y)
);

-- drop table if exists t;
create temp table t (
dwr_id varchar(8),
id_line varchar(120),
wt_mean_awc float,
wt_mean_soil_depth float);

COPY t (id_line,wt_mean_awc,wt_mean_soil_depth) 
from 'statsgo.csv' WITH DELIMITER AS ',' QUOTE AS '"' CSV HEADER;

update t set dwr_id=substring(id_line,1,position(',' in id_line)-1);

insert into statsgo (x,y,AWC,SDx) 
select x,y,wt_mean_awc,wt_mean_soil_depth 
from pixels join t using (dwr_id) 
where dwr_id is NOT NULL;

truncate t;

COPY t (id_line,wt_mean_awc,wt_mean_soil_depth) 
from 'ssurgo.csv' WITH DELIMITER AS ',' QUOTE AS '"' CSV HEADER;

update t set dwr_id=substring(id_line,1,position(',' in id_line)-1);

insert into ssurgo (x,y,AWC,SDx) 
select x,y,wt_mean_awc,wt_mean_soil_depth 
from pixels join t using (dwr_id) 
where dwr_id is NOT NULL;

truncate t;

COPY t (id_line,wt_mean_soil_depth,wt_mean_awc) 
from 'combined.csv' WITH DELIMITER AS ',' QUOTE AS '"' CSV HEADER;

update t set dwr_id=substring(id_line,1,position(',' in id_line)-1);

insert into combined (x,y,AWC,SDx) 
select x,y,wt_mean_awc,wt_mean_soil_depth 
from pixels join t using (dwr_id) 
where dwr_id is NOT NULL;

-- Create the Soils version.
insert into soil (x,y,AWC,SDx) 
select x,y,coalesce(s.awc,t.awc) as AWC, 
           coalesce(s.SDx,t.SDx) as SDx 
from pixels left join combined c using (x,y) 
left join statsgo t using (x,y) 
left join ssurgo s using (x,y);

END;
