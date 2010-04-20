CREATE TEMP TABLE inp (id int,long float,lat float,"date" date,DOY integer,
       	    	      frac_year float,Tx float,Tn float,PCP float,
		      flag_Tx int,flag_Tn int,flag_PCP int);

COPY inp (id,long,lat,date,doy,frac_year,Tx,Tn,PCP,flag_Tx,flag_Tn,flag_PCP) 
FROM '@FILE@' DELIMITER AS ',' CSV HEADER;

INSERT INTO ncdc.stations (id,ncdc_id,long,lat,centroid)
SELECT DISTINCT i.id,substr(id::text,0,5)::int,i.long,i.lat,
                transform(setsrid(MakePoint(i.long,i.lat),4629),3310) as centroid
FROM inp i left join ncdc.stations s using(id) 
WHERE s is Null; 

INSERT INTO ncdc.dates (date,DOY,frac_year)
SELECT DISTINCT i.date,i.DOY,i.frac_year 
FROM inp i left join ncdc.dates d using(date) 
WHERE d is Null;

INSERT INTO ncdc.daily (id,"date","Tx","Tn","PCP","flag_Tx","flag_Tn","flag_PCP")
SELECT id,"date",Tx,Tn,PCP,flag_Tx,flag_Tn,flag_PCP
FROM inp i;
