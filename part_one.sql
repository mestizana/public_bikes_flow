-- SQL with Python

select * from countries ;
select * from stations;
select * from mean_temperature;

ALTER TABLE stations 
ADD FOREIGN KEY (cn) REFERENCES countries(alpha2);

-- Data Wrangling

--1
select count(*) from mean_temperature mt;
-- 116950573 records

--2
select distinct name
from countries c 
order by name;

--3
select cn, count(*) as station_count
from stations s  
group by cn 
order by station_count desc;

--4
select avg(station_elevation) as height_avg, cn as country
from stations s 
group by cn
having cn='CH' or cn='NL';

--5
select station_name, station_elevation
from stations s  
where cn='DE'
order by station_elevation desc 
limit 1;

--6
select * from mean_temperature mt  ;


select cn from stations s 
where cn = 'CH';


--Advanced SQL Queries

--1
create table yearly_mean_temperature as (
select mean_temperature.staid as station_id, date_part('year', date) as year,
mean_temperature.tg as yearly_temp
from mean_temperature  
group by mean_temperature.tg, year, mean_temperature.staid
);

--2
select staid, date, tg,
  case
    when tg > 25 then 'hot'
    when tg >= 10 and tg <= 25 then 'normal'
    else 'cold'
  end as temperature_range
from mean_temperature;

--3
select year, avg(max_temp) as yearly_avg_max_temp
from (
    select extract (year from date) as year, max(tg) as max_temp
    from mean_temperature
    group by extract (year from date), staid
) subquery
group by year;


-- FOR PLOTS

create table wys as
select staid, 
ROUND(AVG(tg)/10, 2) as avg_temp, date_part('year', date) as year, 
from mean_temperature 
group by staid, year;

select * from wys;

CREATE TABLE average_temp_stations AS (
SELECT stations.station_name AS station_name, stations.station_elevation as height, wys.staid, wys.avg_temp, wys."year", stations.latitude as lat, stations.longitude as lon
FROM stations 
FULL JOIN wys
on stations.station_id = wys.staid 
);

select * from average_temp_stations;

CREATE TABLE final_plot AS (
SELECT countries.alpha3 as alpha3, countries.code as code, average_temp_stations.station_name as name, average_temp_stations.height as height, average_temp_stations.staid as id, average_temp_stations.avg_temp as temperature, average_temp_stations."year" as year, average_temp_stations.lat as lat, average_temp_stations.lon as lon
FROM average_temp_stations  
JOIN countries 
on countries."name" = average_temp_stations.station_name 
);


select * from final_plot fp;


query =
    create table wys as(
    SELECT alpha3, ROUND(AVG(yearly_temp), 2) as country_avg, year
    FROM yearly_mean_temperature
    INNER JOIN stations USING (station_id)
    INNER JOIN countries ON stations.cn = countries.alpha2
    WHERE year BETWEEN 1950 AND 2015
    GROUP BY alpha3, year
    ORDER BY alpha3, year);

select * from wys;
