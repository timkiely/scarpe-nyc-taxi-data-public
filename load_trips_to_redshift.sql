-- LOAD YELLOW, GREEN TAXI TRIPS:

DROP TABLE IF EXISTS nyc_taxi_data_v002;
CREATE TABLE nyc_taxi_data_v002 (
    id integer NOT NULL,
    cab_type_id integer,
    vendor_id character varying,
    pickup_datetime TIMESTAMP,
    dropoff_datetime TIMESTAMP,
    store_and_fwd_flag character(1),
    rate_code_id integer,
    pickup_longitude FLOAT,
    pickup_latitude FLOAT,
    dropoff_longitude FLOAT,
    dropoff_latitude FLOAT,
    passenger_count integer,
    trip_distance numeric,
    fare_amount numeric,
    extra numeric,
    mta_tax numeric,
    tip_amount numeric,
    tolls_amount numeric,
    ehail_fee numeric,
    improvement_surcharge numeric,
    total_amount numeric,
    payment_type character varying,
    trip_type integer,
    pickup_nyct2010_gid integer,
    dropoff_nyct2010_gid integer,
    pickup_location_id integer,
    dropoff_location_id integer,
    pickup VARCHAR(max),
    dropoff VARCHAR(max)
);



copy nyc_taxi_data_v002 from 's3://taxi.data.v002/trips.csv.gz'
credentials 'aws_access_key_id=AKIAIRSVNG47S53REZNQ;aws_secret_access_key=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'
GZIP
delimiter '|'
acceptinvchars
ignoreheader 1
dateformat 'auto'
TIMEFORMAT 'auto'
ACCEPTANYDATE
maxerror 10
COMPUPDATE ON;

DROP TABLE IF EXISTS nyc_taxi_data_v002_old;
ALTER TABLE nyc_taxi_data_v002 RENAME TO nyc_taxi_data_v002_old;

DROP TABLE IF EXISTS nyc_taxi_data_v002;
CREATE TABLE nyc_taxi_data_v002 AS 
(
SELECT 
    id integer NOT NULL
    ,cab_type_id integer
    ,vendor_id character varying,
    ,pickup_datetime TIMESTAMP
    ,to_char(pickup_datetime, 'YYYY-MM-DD') as PICKUP_DATE
    ,to_char(pickup_datetime, 'YYYY') as PICKUP_YEAR
    ,to_char(pickup_datetime, 'Q') as PICKUP_QUARTER
    ,to_char(pickup_datetime, 'MM') as PICKUP_MONTH
    ,to_char(pickup_datetime, 'MON') as PICKUP_MONTH_LAB
    ,to_char(pickup_datetime, 'YYYYMM') as PICKUP_YEARMONTH
    ,to_char(pickup_datetime, 'DD') as PICKUP_DAY
    ,to_char(pickup_datetime, 'DY') as PICKUP_DAY_OF_WEEK
    ,to_char(pickup_datetime, 'HH24:MI:SS') as PICKUP_TIME
    ,to_char(pickup_datetime, 'HH24') as PICKUP_HOUR
    ,to_char(pickup_datetime, 'MI') as PICKUP_MIN
    ,to_char(pickup_datetime, 'SS') as PICKUP_SEC

    
    ,dropoff_datetime TIMESTAMP
    ,to_char(dropoff_datetime, 'YYYY-MM-DD') as DROPOFF_DATE
    ,to_char(dropoff_datetime, 'YYYY') as DROPOFF_YEAR
    ,to_char(dropoff_datetime, 'Q') as DROPOFF_QUARTER
    ,to_char(dropoff_datetime, 'MM') as DROPOFF_MONTH
    ,to_char(dropoff_datetime, 'MON') as DROPOFF_MONTH_LAB
    ,to_char(dropoff_datetime, 'YYYYMM') as DROPOFF_YEARMONTH
    ,to_char(dropoff_datetime, 'DD') as DROPOFF_DAY
    ,to_char(dropoff_datetime, 'DY') as DROPOFF_DAY_OF_WEEK
    ,to_char(dropoff_datetime, 'HH24:MI:SS') as DROPOFF_TIME
    ,to_char(dropoff_datetime, 'HH24') as DROPOFF_HOUR
    ,to_char(dropoff_datetime, 'MI') as DROPOFF_MIN
    ,to_char(dropoff_datetime, 'SS') as DROPOFF_SEC
    
    ,store_and_fwd_flag character(1)
    ,rate_code_id integer
    ,pickup_longitude FLOAT
    ,pickup_latitude FLOAT
    ,dropoff_longitude FLOAT
    ,dropoff_latitude FLOAT
    ,passenger_count integer
    ,trip_distance numeric
    ,fare_amount numeric
    ,extra numeric
    ,mta_tax numeric
    ,tip_amount numeric
    ,tolls_amount numeric
    ,ehail_fee numeric
    ,improvement_surcharge numeric
    ,total_amount numeric
    ,payment_type character varying
    ,trip_type integer
    ,pickup_nyct2010_gid integer
    ,dropoff_nyct2010_gid integer
    ,pickup_location_id integer
    ,dropoff_location_id integer
    ,pickup VARCHAR(max)
    ,dropoff VARCHAR(max)
FROM nyc_taxi_data_v002_old);

-- LOAD FHV TAXI TRIPS:

DROP TABLE IF EXISTS nyc_fhv_data_v002;
CREATE TABLE nyc_fhv_data_v002 (
    id integer,
    dispatching_base_num character varying,
    pickup_datetime timestamp without time zone,
    location_id integer,
    gid VARCHAR,
    objectid integer,
    shape_leng numeric,
    shape_area numeric,
    zone character varying(254),
    locationid smallint,
    borough character varying(254),
    nyct2010_gid integer,
    taxi_zone_location_id smallint,
    overlap double precision
);



copy nyc_fhv_data_v002 from 's3://fhv.data.v001/fhv_trips.csv.gz'
credentials 'aws_access_key_id=AKIAIRSVNG47S53REZNQ;aws_secret_access_key=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'
GZIP
delimiter '|'
acceptinvchars
ignoreheader as 1
dateformat 'auto'
timeformat 'auto'
maxerror 10
COMPUPDATE ON;

DROP TABLE IF EXISTS nyc_fhv_data_v002_old;
ALTER TABLE nyc_fhv_data_v002 RENAME TO nyc_fhv_data_v002_old;

DROP TABLE IF EXISTS nyc_fhv_data_v002;
CREATE TABLE nyc_fhv_data_v002 AS 
(
SELECT 
    id
    ,dispatching_base_num
    ,pickup_datetime
    ,to_char(pickup_datetime, 'YYYY-MM-DD') as PICKUP_DATE
    ,to_char(pickup_datetime, 'YYYY') as PICKUP_YEAR
    ,to_char(pickup_datetime, 'Q') as PICKUP_QUARTER
    ,to_char(pickup_datetime, 'MM') as PICKUP_MONTH
    ,to_char(pickup_datetime, 'MON') as PICKUP_MONTH_LAB
    ,to_char(pickup_datetime, 'YYYYMM') as PICKUP_YEARMONTH
    ,to_char(pickup_datetime, 'DD') as PICKUP_DAY
    ,to_char(pickup_datetime, 'DY') as PICKUP_DAY_OF_WEEK
    ,to_char(pickup_datetime, 'HH24:MI:SS') as PICKUP_TIME
    ,to_char(pickup_datetime, 'HH24') as PICKUP_HOUR
    ,to_char(pickup_datetime, 'MI') as PICKUP_MIN
    ,to_char(pickup_datetime, 'SS') as PICKUP_SEC
    ,location_id
    ,gid
    ,objectid
    ,shape_leng
    ,shape_area
    ,zone
    ,locationid
    ,borougH
    ,nyct2010_giD
    ,taxi_zone_location_id
    ,overlap
FROM nyc_fhv_data_v002_old);
