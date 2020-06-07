--Question 1 20/20
select city, count(*) as num_stations
from lala_stations
group by city
having count(*)>=10 and count(*)<20
order by num_stations desc; 

--Question 2 15/20
select ls.city, count(*) as num_trips
from lala_trips as LT
join lala_stations as LS
on LT.start_station_id=LS.station_id
where LT.start_station_id=LT.end_station_id
group by city
order by num_trips desc;

--Question 3 (Wrong output) - 10/20
select t9.city, max(total) as total_pickup_dropoff
from (select ls.city, ls.station_name, count(*) as total
	 from lala_stations as LS
	 join lala_trips as LT
	 on lt.start_station_id=ls.station_id
	 where lt.start_station_id !=lt.end_station_id
	 group by ls.city, ls.station_name) as t9
	 group by 1; 

--Question 4 (wrong output) - 5/20
with t1 as (select lt.bike_id, count(*) as outsidecity
			from lala_stations as LS
			join lala_trips as LT
			on lt.start_station_id=ls.station_id
		  group by bike_id,lt.start_station_id,lt.end_station_id 
			having lt.start_station_id != lt.end_station_id
)
select t1.bike_id, sum(outsidecity) as totaltimes
from t1
group by t1.bike_id;

--Question 5 (wrong output, include all the events) 5/20
select t10.zip_code, t10.start_station_id, max(total_trips) 
	  from(
select lw.zip_code, lt.start_station_id, count(*) as total_trips
from lala_weather LW
join lala_stations LS
on LW.zip_code=LS.zip_code
join lala_trips LT
on LT.start_station_id=LS.station_id
where events='Fog'
group by lw.zip_code, lt.start_station_id) as t10
group by 1,2;

--Question 6 Extra Credit (select all the station_names with greater than 15 docks and  installation year in 2014) - 20/20
select station_name
from lala_stations as LS
where dock_count>15 and  installation_date=date_part('year', installation_date)=2014