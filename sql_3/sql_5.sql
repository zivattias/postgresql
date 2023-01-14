--Display amount of rides for each route
select
	id,
	count(*)
from
	routes
group by
	id;

--display amount of rides for each route and each weekday
select
	routes.id as route_id,
	r.weekday,
	count(*) as ride_amnt
from
	routes
join rides r on
	routes.id = r.route_id
group by
	routes.id,
	r.weekday
order by
	routes.id;

--display route with most rides
select
	route_id,
	count(route_id) as amnt_rides
from
	rides
group by
	route_id
order by
	amnt_rides desc
limit 1;

--get the weekday that has most rides for route 200
select
	weekday,
	count(weekday)
from
	rides
where
	route_id = (
	select
		id
	from
		routes
	where
		route_num = 200)
group by
	weekday
order by
	weekday desc
limit 1;

--Get all the routes that have stops in Haifa Matam
-- stop_id = 4
select * from (select id as route_id from routes where orig_stop_id = 4 or dest_stop_id = 4) as orig_dest union select * from (select id from rides where id = (select ride_id from ride_stops where stop_id = 4)) as stops;

select
	r.route_num
from
	routes r
join (select * from (select id as route_id from routes where orig_stop_id = 4 or dest_stop_id = 4) as orig_dest union select * from (select id from rides where id = (select ride_id from ride_stops where stop_id = 4)) as stops) as combined
on combined.route_id = r.id;

--select id as route_id from routes where orig_stop_id = 4 or dest_stop_id = 4;
--select id from rides where id = (select ride_id from ride_stops where stop_id = 4);


--Get driver names and amount of routes they drove
--select name from drivers;

select
	drivers."name",
	count(route_id) rides_amnt
from
	rides
join drivers on
	rides.driver_id = drivers.id
group by
	drivers.name
order by
	rides_amnt desc;


--Display driver names and total time they drove. Note, you should not take into account canceled rides.
select
	d."name",
	sum(r2.arrival_time - r2.departure_time) len_rides
from
	drivers d
left join rides r1 on
	d.id = r1.driver_id
left join ride_stops r2 on
	r1.route_id = r2.id
left join service_interruptions si1 on
	si1.ride_id = r1.id
where
	si1.interrupt_type <> 'cancelation'
group by
	d."name",
    r2.arrival_time - r2.departure_time;

--Get all the driver names who drive on route 100
select
	d."name"
from
	drivers d
join
(
	select
		driver_id
	from
		rides
	where
		rides.route_id = (
		select
			id
		from
			routes
		where
			route_num = 100)) as ids on
	d.id = ids.driver_id;


--Get all the routes which rides last more than 1 hour
select
	distinct on
	(route_id) route_id,
	lengths.ride_len as len_in_hours
from
	rides
join (
	select
		ride_id,
		min(arrival_time) as arrival,
		max(departure_time) as departure,
		(max(departure_time) - min(arrival_time)) as ride_len
	from
		ride_stops
	group by
		ride_id) as lengths on
	lengths.ride_len > interval '1 hour';

select * from rides;
select * from routes;
select * from ride_stops;

select rides.id as ride_id, min(ride_stops.stop_ordinal) as orig, max(ride_stops.stop_ordinal) as dest from rides join ride_stops on rides.id = ride_stops.ride_id group by rides.id;

select ride_stops.arrival_time from ride_stops join (select rides.id as ride_id, min(ride_stops.stop_ordinal) as orig, max(ride_stops.stop_ordinal) as dest from rides join ride_stops on rides.id = ride_stops.ride_id group by rides.id) as times on ride_stops.stop_id =


select distinct on(stop_id) stop_id, arrival_time from (select stop_id, departure_time, arrival_time from ride_stops) as times join routes on stop_id = routes.orig_stop_id or stop_id = routes.dest_stop_id ;

select routes.id as route_id, routes.orig_stop_id, routes.dest_stop_id from routes;
--Display driver names, and amount of delays for each in the rides they drove
select
	d."name",
	ride_id,
	delays_amnt
from
	drivers d
join (
	select
		count(rides.id) as delays_amnt,
		rides.driver_id,
		rides.id as ride_id
	from
		rides
	join (
		select
			ride_id
		from
			service_interruptions si) as delayed_rides on
		rides.id = delayed_rides.ride_id
	group by
		rides.driver_id,
		rides.id) as dd on
	d.id = dd.driver_id;
