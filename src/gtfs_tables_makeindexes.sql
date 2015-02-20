

begin;

ALTER TABLE agency ADD CONSTRAINT agency_name_pkey
      PRIMARY KEY (agency_id);
ALTER TABLE agency
      ALTER COLUMN agency_name SET NOT NULL;
ALTER TABLE agency
      ALTER COLUMN agency_url SET NOT NULL;
ALTER TABLE agency
      ALTER COLUMN agency_timezone SET NOT NULL;

ALTER TABLE stops ADD CONSTRAINT stops_id_pkey
      PRIMARY KEY (stop_id);
ALTER TABLE stops
      ALTER COLUMN stop_name SET NOT NULL;
ALTER TABLE stops ADD CONSTRAINT stop_location_fkey
      FOREIGN KEY (location_type)
      REFERENCES location_types(location_type);
ALTER TABLE stops ADD CONSTRAINT stop_parent_fkey
      FOREIGN KEY (parent_station)
      REFERENCES stops(stop_id);


ALTER TABLE routes ADD CONSTRAINT routes_id_pkey
      PRIMARY KEY (route_id);
ALTER TABLE routes ADD CONSTRAINT routes_agency_fkey
      FOREIGN KEY (agency_id)
      REFERENCES agency(agency_id);
ALTER TABLE routes ADD CONSTRAINT routes_rtype_fkey
      FOREIGN KEY (route_type)
      REFERENCES route_types(route_type);

ALTER TABLE calendar ADD CONSTRAINT calendar_sid_pkey
      PRIMARY KEY (service_id);
ALTER TABLE calendar
      ALTER COLUMN monday SET NOT NULL;
ALTER TABLE calendar
      ALTER COLUMN tuesday SET NOT NULL;
ALTER TABLE calendar
      ALTER COLUMN wednesday SET NOT NULL;
ALTER TABLE calendar
      ALTER COLUMN thursday SET NOT NULL;
ALTER TABLE calendar
      ALTER COLUMN friday SET NOT NULL;
ALTER TABLE calendar
      ALTER COLUMN saturday SET NOT NULL;
ALTER TABLE calendar
      ALTER COLUMN sunday SET NOT NULL;
ALTER TABLE calendar
      ALTER COLUMN start_date SET NOT NULL;
ALTER TABLE calendar
      ALTER COLUMN end_date SET NOT NULL;

--ALTER TABLE calendar_dates ADD CONSTRAINT cal_sid_fkey
--      FOREIGN KEY (service_id)
--      REFERENCES calendar(service_id);

ALTER TABLE fare_attributes ADD CONSTRAINT fare_id_pkey
      PRIMARY KEY (fare_id);
ALTER TABLE fare_attributes
      ALTER COLUMN price SET NOT NULL;
ALTER TABLE fare_attributes
      ALTER COLUMN currency_type SET NOT NULL;
ALTER TABLE fare_attributes ADD CONSTRAINT fare_pay_fkey
      FOREIGN KEY (payment_method)
      REFERENCES payment_methods(payment_method);
ALTER TABLE fare_attributes ADD CONSTRAINT fare_agency_fkey
      FOREIGN KEY (agency_id)
      REFERENCES agency(agency_id);

ALTER TABLE fare_rules ADD CONSTRAINT farer_id_pkey
      FOREIGN KEY (fare_id)
      REFERENCES fare_attributes(fare_id);
ALTER TABLE fare_rules ADD CONSTRAINT fare_rid_fkey
      FOREIGN KEY (route_id)
      REFERENCES routes(route_id);

ALTER TABLE shapes
      ALTER COLUMN shape_id SET NOT NULL;
ALTER TABLE shapes
      ALTER COLUMN shape_pt_lat SET NOT NULL;
ALTER TABLE shapes
      ALTER COLUMN shape_pt_lon SET NOT NULL;
ALTER TABLE shapes
      ALTER COLUMN shape_pt_sequence SET NOT NULL;

ALTER TABLE trips ADD CONSTRAINT trip_id_pkey
      PRIMARY KEY (trip_id);
ALTER TABLE trips ADD CONSTRAINT trip_rid_fkey
      FOREIGN KEY (route_id)
      REFERENCES routes(route_id);
--ALTER TABLE trips ADD CONSTRAINT trip_sid_fkey
--      FOREIGN KEY (service_id)
--      REFERENCES calendar(service_id);
ALTER TABLE trips ADD CONSTRAINT trip_did_fkey
      FOREIGN KEY (direction_id)
      REFERENCES directions(direction_id);
ALTER TABLE trips
      ALTER COLUMN direction_id SET NOT NULL;

ALTER TABLE stop_times ADD CONSTRAINT times_tid_fkey
      FOREIGN KEY (trip_id)
      REFERENCES trips(trip_id);
ALTER TABLE stop_times ADD CONSTRAINT times_sid_fkey
      FOREIGN KEY (stop_id)
      REFERENCES stops(stop_id);
ALTER TABLE stop_times ADD CONSTRAINT times_ptype_fkey
      FOREIGN KEY (pickup_type)
      REFERENCES pickup_dropoff_types(type_id);
ALTER TABLE stop_times ADD CONSTRAINT times_dtype_fkey
      FOREIGN KEY (drop_off_type)
      REFERENCES pickup_dropoff_types(type_id);
ALTER TABLE stop_times ADD CONSTRAINT times_arrtime_check
      CHECK (arrival_time LIKE '__:__:__');
ALTER TABLE stop_times ADD CONSTRAINT times_deptime_check
      CHECK (departure_time LIKE '__:__:__');
ALTER TABLE stop_times
      ALTER COLUMN stop_sequence SET NOT NULL;

create index arr_time_index on stop_times(arrival_time_seconds);
create index dep_time_index on stop_times(departure_time_seconds);
create index stop_seq_index on stop_times(trip_id,stop_sequence);

ALTER TABLE frequencies ADD CONSTRAINT freq_tid_fkey
      FOREIGN KEY (trip_id)
      REFERENCES trips(trip_id);
ALTER TABLE frequencies
      ALTER COLUMN start_time SET NOT NULL;
ALTER TABLE frequencies
      ALTER COLUMN end_time SET NOT NULL;
ALTER TABLE frequencies
      ALTER COLUMN headway_secs SET NOT NULL;


ALTER TABLE transfers ADD CONSTRAINT xfer_fsid_fkey
      FOREIGN KEY (from_stop_id)
      REFERENCES stops(stop_id);
ALTER TABLE transfers ADD CONSTRAINT xfer_tsid_fkey
      FOREIGN KEY (to_stop_id)
      REFERENCES stops(stop_id);
ALTER TABLE transfers ADD CONSTRAINT xfer_xt_fkey
      FOREIGN KEY (transfer_type)
      REFERENCES transfer_types(transfer_type);
ALTER TABLE transfers ADD CONSTRAINT xfer_frid_fkey
      FOREIGN KEY (from_route_id)
      REFERENCES routes(route_id);
ALTER TABLE transfers ADD CONSTRAINT xfer_trid_fkey
      FOREIGN KEY (to_route_id)
      REFERENCES routes(route_id);
--ALTER TABLE transfers ADD CONSTRAINT xfer_sid_fkey
--      FOREIGN KEY (service_id)
--      REFERENCES calendar(service_id);


commit;
