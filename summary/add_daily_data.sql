\set ON_ERROR_STOP 1
BEGIN;
set search_path=summary,public;

truncate daily:r;

insert into daily:r ( x,y,year,month,doy,quad,days,
 tx,tx_stddev,tx_min,tx_max,
 tn,tn_stddev,tn_min,tn_max,
 pcp,pcp_stddev,pcp_min,pcp_max,nrf)
select x,y,extract(year from ymd) as year,
           extract(month from ymd) as month,
	   Null as doy,
	   Null as quad,
           count(*) as days,
           avg(tx) as tx,stddev(tx) as tx_stddev,
           min(tx) as tx_min,max(tx) as tx_max,
           avg(tn) as tn, stddev(tn) as tn_stddev,
           min(tn) as tn_min,max(tn) as tn_max,
           sum(pcp) as pcp,stddev(pcp) as pcp_stdev, 
	   min(pcp) as pcp_min,max(pcp) as pcp_max,
           sum(CASE WHEN rf is TRUE THEN 1 ELSE 0 END) as nrf 
from daily4km.daily:r 
group by x,y,extract(year from ymd),extract(month from ymd) 
order by x,y,year,month;

END;