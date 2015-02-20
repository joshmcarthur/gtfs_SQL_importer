drop table agency cascade;
drop table stops cascade;
drop table routes cascade;
drop table calendar cascade;
drop table calendar_dates cascade;
drop table fare_attributes cascade;
drop table fare_rules cascade;
drop table shapes cascade;
drop table trips cascade;
drop table stop_times cascade;
drop table frequencies cascade;

drop table transfers cascade;
drop table feed_info cascade;

drop table route_types cascade;
drop table directions cascade;
drop table pickup_dropoff_types cascade;
drop table payment_methods cascade;

drop table location_types cascade;
drop table wheelchair_boardings cascade;
drop table transfer_types cascade;

drop table service_combo_ids cascade;
drop table service_combinations cascade;

begin;

create table agency (
  agency_id    text ,--PRIMARY KEY,
  agency_name  text ,--NOT NULL,
  agency_url   text ,--NOT NULL,
  agency_timezone    text ,--NOT NULL,
  agency_lang  text,
  agency_phone text,
  agency_fare_url text
);

--related to stops(location_type)
create table location_types (
  location_type int PRIMARY KEY,
  description text
);

insert into location_types(location_type, description)
       values (0,'stop');
insert into location_types(location_type, description)
       values (1,'station');
insert into location_types(location_type, description)
       values (2,'station entrance');

--related to gtf_stops(wheelchair_boarding)
create table wheelchair_boardings (
  wheelchair_boarding int PRIMARY KEY,
  description text
);

insert into wheelchair_boardings(wheelchair_boarding, description)
       values (0, 'No accessibility information available for the stop');
insert into wheelchair_boardings(wheelchair_boarding, description)
       values (1, 'At least some vehicles at this stop can be boarded by a rider in a wheelchair');
insert into wheelchair_boardings(wheelchair_boarding, description)
       values (2, 'Wheelchair boarding is not possible at this stop');


create table stops (
  stop_id    text ,--PRIMARY KEY,
  stop_name  text , --NOT NULL,
  stop_desc  text,
  stop_lat   double precision,
  stop_lon   double precision,
  zone_id    text,
  stop_url   text,
  stop_code  text,

  -- new
  stop_street text,
  stop_city   text,
  stop_region text,
  stop_postcode text,
  stop_country text,

  -- unofficial features

  location_type int, --FOREIGN KEY REFERENCES location_types(location_type)
  parent_station text, --FOREIGN KEY REFERENCES stops(stop_id)
  stop_timezone text,
  wheelchair_boarding int --FOREIGN KEY REFERENCES wheelchair_boardings(wheelchair_boarding)
  -- Unofficial fields
  ,
  direction text,
  position text
);

-- select AddGeometryColumn( 'stops', 'location', #{WGS84_LATLONG_EPSG}, 'POINT', 2 );
-- CREATE INDEX stops_location_ix ON stops USING GIST ( location GIST_GEOMETRY_OPS );

create table route_types (
  route_type int PRIMARY KEY,
  description text
);

insert into route_types (route_type, description) values (0, 'Street Level Rail');
insert into route_types (route_type, description) values (1, 'Underground Rail');
insert into route_types (route_type, description) values (2, 'Intercity Rail');
insert into route_types (route_type, description) values (3, 'Bus');
insert into route_types (route_type, description) values (4, 'Ferry');
insert into route_types (route_type, description) values (5, 'Cable Car');
insert into route_types (route_type, description) values (6, 'Suspended Car');
insert into route_types (route_type, description) values (7, 'Steep Incline Mode');


create table routes (
  route_id    text ,--PRIMARY KEY,
  agency_id   text , --REFERENCES agency(agency_id),
  route_short_name  text DEFAULT '',
  route_long_name   text DEFAULT '',
  route_desc  text,
  route_type  int , --REFERENCES route_types(route_type),
  route_url   text,
  route_color text,
  route_text_color  text
);

create table directions (
  direction_id int PRIMARY KEY,
  description text
);

insert into directions (direction_id, description) values (0,'This way');
insert into directions (direction_id, description) values (1,'That way');


create table pickup_dropoff_types (
  type_id int PRIMARY KEY,
  description text
);

insert into pickup_dropoff_types (type_id, description) values (0,'Regularly Scheduled');
insert into pickup_dropoff_types (type_id, description) values (1,'Not available');
insert into pickup_dropoff_types (type_id, description) values (2,'Phone arrangement only');
insert into pickup_dropoff_types (type_id, description) values (3,'Driver arrangement only');



-- CREATE INDEX gst_trip_id_stop_sequence ON stop_times (trip_id, stop_sequence);

create table calendar (
  service_id   text ,--PRIMARY KEY,
  monday int , --NOT NULL,
  tuesday int , --NOT NULL,
  wednesday    int , --NOT NULL,
  thursday     int , --NOT NULL,
  friday int , --NOT NULL,
  saturday     int , --NOT NULL,
  sunday int , --NOT NULL,
  start_date   date , --NOT NULL,
  end_date     date  --NOT NULL
);

create table calendar_dates (
  service_id     text , --REFERENCES calendar(service_id),
  date     date , --NOT NULL,
  exception_type int  --NOT NULL
);

-- The following two tables are not in the spec, but they make dealing with dates and services easier
create table service_combo_ids
(
combination_id serial --primary key
);
create table service_combinations
(
combination_id int , --references service_combo_ids(combination_id),
service_id text --references calendar(service_id)
);


create table payment_methods (
  payment_method int PRIMARY KEY,
  description text
);

insert into payment_methods (payment_method, description) values (0,'On Board');
insert into payment_methods (payment_method, description) values (1,'Prepay');


create table fare_attributes (
  fare_id     text ,--PRIMARY KEY,
  price double precision , --NOT NULL,
  currency_type     text , --NOT NULL,
  payment_method    int , --REFERENCES payment_methods,
  transfers   int,
  transfer_duration int
  -- unofficial features
  ,
  agency_id text  --REFERENCES agency(agency_id)
);

create table fare_rules (
  fare_id     text , --REFERENCES fare_attributes(fare_id),
  route_id    text , --REFERENCES routes(route_id),
  origin_id   text ,
  destination_id text ,
  contains_id text
  -- unofficial features
  ,
  service_id text -- REFERENCES calendar(service_id) ?
);

create table shapes (
  shape_id    text , --NOT NULL,
  shape_pt_lat double precision , --NOT NULL,
  shape_pt_lon double precision , --NOT NULL,
  shape_pt_sequence int , --NOT NULL,
  shape_dist_traveled double precision
);

create table trips (
  route_id text , --REFERENCES routes(route_id),
  service_id    text , --REFERENCES calendar(service_id),
  trip_id text ,--PRIMARY KEY,
  trip_headsign text,
  direction_id  int , --REFERENCES directions(direction_id),
  block_id text,
  shape_id text,
  trip_short_name text,
  -- unofficial features
  trip_type text
);

create table stop_times (
  trip_id text , --REFERENCES trips(trip_id),
  arrival_time text, -- CHECK (arrival_time LIKE '__:__:__'),
  departure_time text, -- CHECK (departure_time LIKE '__:__:__'),
  stop_id text , --REFERENCES stops(stop_id),
  stop_sequence int , --NOT NULL,
  stop_headsign text,
  pickup_type   int , --REFERENCES pickup_dropoff_types(type_id),
  drop_off_type int , --REFERENCES pickup_dropoff_types(type_id),
  shape_dist_traveled double precision

  -- unofficial features
  ,
  timepoint int

  -- the following are not in the spec
  ,
  arrival_time_seconds int,
  departure_time_seconds int

);

--create index arr_time_index on stop_times(arrival_time_seconds);
--create index dep_time_index on stop_times(departure_time_seconds);

-- select AddGeometryColumn( 'shapes', 'shape', #{WGS84_LATLONG_EPSG}, 'LINESTRING', 2 );

create table frequencies (
  trip_id     text , --REFERENCES trips(trip_id),
  start_time  text , --NOT NULL,
  end_time    text , --NOT NULL,
  headway_secs int , --NOT NULL
  exact_times int,
  start_time_seconds int,
  end_time_seconds int
);





create table transfer_types (
  transfer_type int PRIMARY KEY,
  description text
);

insert into transfer_types (transfer_type, description)
       values (0,'Preferred transfer point');
insert into transfer_types (transfer_type, description)
       values (1,'Designated transfer point');
insert into transfer_types (transfer_type, description)
       values (2,'Transfer possible with min_transfer_time window');
insert into transfer_types (transfer_type, description)
       values (3,'Transfers forbidden');


create table transfers (
  from_stop_id text, --REFERENCES stops(stop_id)
  to_stop_id text, --REFERENCES stops(stop_id)
  transfer_type int, --REFERENCES transfer_types(transfer_type)
  min_transfer_time int,
  -- Unofficial fields
  from_route_id text, --REFERENCES routes(route_id)
  to_route_id text, --REFERENCES routes(route_id)
  service_id text --REFERENCES calendar(service_id) ?
);


create table feed_info (
  feed_publisher_name text,
  feed_publisher_url text,
  feed_timezone text,
  feed_lang text,
  feed_version text,
  feed_start_date text,
  feed_end_date text
);



commit;
