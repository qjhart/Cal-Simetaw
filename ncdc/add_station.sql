\set ON_ERROR_STOP 1
BEGIN;
set search_path=ncdc,public;

create temp table inp (
 l varchar(170)
);

COPY inp (l) FROM 'stn.txt' WITH CSV HEADER;

delete from inp where l like '--%';

insert into station (
coopid,wbnid,name,country,state,county,cd,latitude,longitude,elevation
)
select
substring(l from 1 for 6)::varchar(6) as coopid,
substring(l from 9 for 5)::integer as wbnid,
trim(both ' ' from substring(l from 15 for 30)) as name,
trim(both ' ' from substring(l from 46 for 30)) as country,
trim(both ' ' from substring(l from 79 for 4)) as state,
trim(both ' ' from substring(l from 86 for 30)) as county,
trim(both ' ' from substring(l from 118 for 16)) as cd,
substring(l from 137 for 2)::float+substring(l from 140 for 2)::float/60.0 latitude,
substring(l from 148 for 4)::float-substring(l from 153 for 2)::float/60.0 longitude,
substring(l from 160 for 6)::float as elevation
from inp
left join station s 
on (substring(l from 1 for 6)::varchar(6) = s.coopid and substring(l from 9 for 5)::integer=s.wbnid)
where s is Null;

update station 
set centroid=transform(setSRID(MakePoint(longitude,latitude),4269),3310) 
where centroid is Null;

END;

