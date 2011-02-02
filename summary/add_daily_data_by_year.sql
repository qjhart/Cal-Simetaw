-- This isn't used in the makefiles, just something I use currently
-- need to set the --variable=yr=2005 --variable=mn=04 to work.
\set ON_ERROR_STOP 1
BEGIN;
set search_path=:dailySchema,public;

truncate daily_summary:r;

insert into daily_summary:r ( x,y,year,month,days,
 tx,tx_min,tx_max,tx_stddev,
 tn,tn_min,tn_max,tn_stddev,pcp,pcp_min,pcp_max,nrf)
select x,y,extract(year from ymd) as year,
           extract(month from ymd) as month, 
           count(*) as days,
           avg(tx) as tx,stddev(tx) as tx_stddev,
           min(tx) as tx_min,max(tx) as tx_max,
           avg(tn) as tn, stddev(tn) as tn_stddev,
           min(tn) as tn_min,max(tn) as tn_max,
           sum(pcp) as pcp, 
	   min(pcp) as pcp_min,max(pcp) as pcp_max,
           sum(CASE WHEN rf is TRUE THEN 1 ELSE 0 END) as nrf 
from daily4km.daily:r 
where extract(year from ymd)=:yr and 
extract(month from ymd)=:mn
group by x,y,extract(year from ymd),extract(month from ymd) 
order by x,y,year,month;

END;