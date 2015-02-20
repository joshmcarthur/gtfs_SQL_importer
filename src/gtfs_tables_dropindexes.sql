drop index arr_time_index;
drop index dep_time_index;
drop index stop_seq_index;

ALTER TABLE agency DROP CONSTRAINT agency_name_pkey CASCADE;
ALTER TABLE stops DROP CONSTRAINT stops_id_pkey CASCADE;
ALTER TABLE stops DROP CONSTRAINT stop_location_fkey CASCADE;
ALTER TABLE stops DROP CONSTRAINT stop_parent_fkey CASCADE;
ALTER TABLE routes DROP CONSTRAINT routes_id_pkey CASCADE;
ALTER TABLE routes DROP CONSTRAINT routes_agency_fkey CASCADE;
ALTER TABLE routes DROP CONSTRAINT routes_rtype_fkey CASCADE;
ALTER TABLE calendar DROP CONSTRAINT calendar_sid_pkey CASCADE;
ALTER TABLE calendar_dates DROP CONSTRAINT cal_sid_fkey CASCADE;
ALTER TABLE fare_attributes DROP CONSTRAINT fare_id_pkey CASCADE;
ALTER TABLE fare_attributes DROP CONSTRAINT fare_pay_fkey CASCADE;
ALTER TABLE fare_attributes DROP CONSTRAINT fare_agency_fkey CASCADE;
ALTER TABLE fare_rules DROP CONSTRAINT fare_rid_pkey CASCADE;
ALTER TABLE fare_rules DROP CONSTRAINT fare_rid_fkey CASCADE;
ALTER TABLE shapes DROP CONSTRAINT shape_shape_constr ;
ALTER TABLE trips DROP CONSTRAINT trip_id_pkey CASCADE;
ALTER TABLE trips DROP CONSTRAINT trip_rid_fkey CASCADE;
ALTER TABLE trips DROP CONSTRAINT trip_sid_fkey CASCADE;
ALTER TABLE trips DROP CONSTRAINT trip_did_fkey CASCADE;
ALTER TABLE stop_times DROP CONSTRAINT times_tid_fkey CASCADE;
ALTER TABLE stop_times DROP CONSTRAINT times_sid_fkey CASCADE;
ALTER TABLE stop_times DROP CONSTRAINT times_ptype_fkey CASCADE;
ALTER TABLE stop_times DROP CONSTRAINT times_dtype_fkey CASCADE;
ALTER TABLE stop_times DROP CONSTRAINT times_arrtime_check;
ALTER TABLE stop_times DROP CONSTRAINT times_deptime_check;
ALTER TABLE frequencies DROP CONSTRAINT freq_tid_fkey CASCADE;
ALTER TABLE transfers DROP CONSTRAINT xfer_fsid_fkey CASCADE;
ALTER TABLE transfers DROP CONSTRAINT xfer_tsid_fkey CASCADE;
ALTER TABLE transfers DROP CONSTRAINT xfer_xt_fkey CASCADE;
ALTER TABLE transfers DROP CONSTRAINT xfer_frid_fkey CASCADE;
ALTER TABLE transfers DROP CONSTRAINT xfer_trid_fkey CASCADE;
ALTER TABLE transfers DROP CONSTRAINT xfer_sid_fkey CASCADE;


ALTER TABLE agency
      ALTER COLUMN agency_name DROP NOT NULL;
ALTER TABLE agency
      ALTER COLUMN agency_url DROP NOT NULL;
ALTER TABLE agency
      ALTER COLUMN agency_timezone DROP NOT NULL;
ALTER TABLE stops
      ALTER COLUMN stop_name DROP NOT NULL;
ALTER TABLE calendar
      ALTER COLUMN monday DROP NOT NULL;
ALTER TABLE calendar
      ALTER COLUMN tuesday DROP NOT NULL;
ALTER TABLE calendar
      ALTER COLUMN wednesday DROP NOT NULL;
ALTER TABLE calendar
      ALTER COLUMN thursday DROP NOT NULL;
ALTER TABLE calendar
      ALTER COLUMN friday DROP NOT NULL;
ALTER TABLE calendar
      ALTER COLUMN saturday DROP NOT NULL;
ALTER TABLE calendar
      ALTER COLUMN sunday DROP NOT NULL;
ALTER TABLE calendar
      ALTER COLUMN start_date DROP NOT NULL;
ALTER TABLE calendar
      ALTER COLUMN end_date DROP NOT NULL;
ALTER TABLE fare_attributes
      ALTER COLUMN price DROP NOT NULL;
ALTER TABLE fare_attributes
      ALTER COLUMN currency_type DROP NOT NULL;
ALTER TABLE shapes
      ALTER COLUMN shape_id DROP NOT NULL;
ALTER TABLE shapes
      ALTER COLUMN shape_pt_lat DROP NOT NULL;
ALTER TABLE shapes
      ALTER COLUMN shape_pt_lon DROP NOT NULL;
ALTER TABLE shapes
      ALTER COLUMN shape_pt_sequence DROP NOT NULL;
ALTER TABLE trips
      ALTER COLUMN direction_id DROP NOT NULL;
ALTER TABLE stop_times
      ALTER COLUMN stop_sequence DROP NOT NULL;
ALTER TABLE frequencies
      ALTER COLUMN start_time DROP NOT NULL;
ALTER TABLE frequencies
      ALTER COLUMN end_time DROP NOT NULL;
ALTER TABLE frequencies
      ALTER COLUMN headway_secs DROP NOT NULL;

