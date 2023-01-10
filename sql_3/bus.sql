-- Tables creation:

create table drivers (
	driver_id serial primary key,
	passport_num integer unique not null,
	fullname varchar(80) not null,
	address varchar(256) not null
);

create table rides (
	ride_id serial primary key,
	route_id integer unique not null,
	route_num integer not null,
	driver_id integer not null,
	foreign key (driver_id) references drivers (driver_id)
);

create table interruptions (
	id serial primary key,
	interruption_type varchar(6) check (interruption_type in ('delay', 'cancel')),
	ts timestamp not null,
	ride_id integer not null,
	foreign key (ride_id) references rides (ride_id)
);

create table ride_stops (
	id serial primary key,
	ride_id integer not null,
	stop_id integer not null,
	stop_ordinal serial not null,
	arrival_time time not null,
	departure_time time check (departure_time < arrival_time),
	foreign key (ride_id) references rides (ride_id),
	unique (stop_id)
);

create table routes (
	route_id serial primary key,
	route_num integer not null,
	origin_stop_id integer not null,
	destination_stop_id integer not null,
	foreign key (route_id) references rides (route_id),
	unique (origin_stop_id),
	unique (destination_stop_id)
);

create table stops (
	stop_id serial not null,
	city_name varchar(100) not null,
	stop_name varchar(256) not null,
	foreign key (stop_id) references ride_stops (stop_id),
	foreign key (stop_id) references routes (origin_stop_id),
	foreign key (stop_id) references routes (destination_stop_id)
);

-- Minor after-the-fact changes:

alter table stops add primary key (stop_id);
alter table drivers alter column passport_num type varchar(40);


-- Data insertion:

-- Drivers:
insert into drivers (passport_num, fullname, address) values ('670-45-5004', 'Karla Claughton', '48868 Jay Circle');
insert into drivers (passport_num, fullname, address) values ('595-30-4580', 'Hayden Dowderswell', '39331 Canary Park');
insert into drivers (passport_num, fullname, address) values ('490-63-2385', 'Dieter Justham', '79184 Sunnyside Pass');
insert into drivers (passport_num, fullname, address) values ('827-63-0848', 'Delcina Mossman', '9 Fallview Junction');
insert into drivers (passport_num, fullname, address) values ('518-87-9435', 'Patti Habard', '355 Porter Plaza');

-- Rides:
insert into rides (route_id, route_num, driver_id) values (1, 10, 10);
insert into rides (route_id, route_num, driver_id) values (2, 10, 6);
insert into rides (route_id, route_num, driver_id) values (3, 10, 7);
insert into rides (route_id, route_num, driver_id) values (5, 11, 8);
insert into rides (route_id, route_num, driver_id) values (6, 11, 8);
insert into rides (route_id, route_num, driver_id) values (7, 11, 9);

-- Routes:
insert into routes (route_num, origin_stop_id, destination_stop_id) values (10, 1, 2);
insert into routes (route_num, origin_stop_id, destination_stop_id) values (10, 2, 1);
insert into routes (route_num, origin_stop_id, destination_stop_id) values (10, 5, 6);
insert into routes (route_id, route_num, origin_stop_id, destination_stop_id) values (5, 11, 3, 4);
insert into routes (route_num, origin_stop_id, destination_stop_id) values (11, 4, 3);
insert into routes (route_id, route_num, origin_stop_id, destination_stop_id) values (7, 11, 6, 5);

-- Ride Stops:
insert into ride_stops (ride_id, stop_id, stop_ordinal, arrival_time, departure_time) values (2, 1, 1, '08:00:00', '07:30:00');
insert into ride_stops (ride_id, stop_id, stop_ordinal, arrival_time, departure_time) values (2, 2, 2, '08:10:00', '08:05:00');
insert into ride_stops (ride_id, stop_id, stop_ordinal, arrival_time, departure_time) values (2, 3, 3, '08:20:00', '08:10:00');
insert into ride_stops (ride_id, stop_id, stop_ordinal, arrival_time, departure_time) values (2, 4, 4, '08:30:00', '08:20:00');
insert into ride_stops (ride_id, stop_id, stop_ordinal, arrival_time, departure_time) values (3, 5, 1, '08:00:00', '07:30:00');

-- Interruptions:
insert into interruptions (interruption_type, ts, ride_id) values ('delay', '2022-01-09 23:00:00', 2);
insert into interruptions (interruption_type, ts, ride_id) values ('delay', '2022-01-09 15:00:00', 2);
insert into interruptions (interruption_type, ts, ride_id) values ('cancel', '2022-01-08 09:00:00', 2);
insert into interruptions (interruption_type, ts, ride_id) values ('delay', now(), 3);
insert into interruptions (interruption_type, ts, ride_id) values ('cancel', '2022-01-10 23:01:20', 3);

-- Stops:
insert into stops (city_name, stop_name) values ('Tel Aviv', 'HaBima');
insert into stops (city_name, stop_name) values ('Tel Aviv', 'Rothschild Blvd');
insert into stops (city_name, stop_name) values ('Tel Aviv', 'Shmaryahu Levin St');
insert into stops (city_name, stop_name) values ('Tel Aviv', 'Washington Blvd');
insert into stops (stop_id, city_name, stop_name) values (5, 'Jaffa', 'Jerusalem Blvd');