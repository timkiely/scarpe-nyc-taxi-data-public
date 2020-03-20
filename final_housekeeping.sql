vacuum;
analyze;


-- SEND TO S3
-- Last runtime: 1 hr 28 min
UNLOAD ('select * from nyc_fhv_data_v002')
TO 's3://taxi.data.bak/FHV/FHV_'
credentials #


UNLOAD ('select * from nyc_taxi_data_v002')
TO 's3://taxi.data.bak/MAIN/MAIN_'
credentials #
