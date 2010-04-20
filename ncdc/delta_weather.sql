drop table if exists ncdc.m_delta_weather;
create table ncdc.m_delta_weather as select * from ncdc.delta_weather limit 0;
select addGeometryColumn('ncdc','m_delta_weather','centroid',3310,'POINT',2);
insert into ncdc.m_delta_weather 
select w.*,s.centroid from ncdc.station s join ncdc.delta_weather w using (station_id);
create index m_delta_weather_day on ncdc.m_delta_weather(day);
create index m_delta_weather_elem on ncdc.m_delta_weather(elem);
