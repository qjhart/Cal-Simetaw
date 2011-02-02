\set ON_ERROR_STOP 1
BEGIN;
set search_path=:dailySchema,public;

create index x_daily:r on daily4km.daily:r(x); 
create index ymd_daily:r on daily4km.daily:r(ymd); 

END;