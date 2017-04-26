#!/bin/bash

echo "`date` creating fhv trips csv"
psql nyc-taxi-data -c "copy (select * from fhv_trips) to '/home/ubuntu/nyc-taxi-data/fhv_trips.csv' delimiter '|'";
echo "`date` fhv trips csv done"

echo "`date` starting zip job"
gzip fhv_trips.csv
echo "`date` zip job finished"

echo "`date` starting upload"
aws s3 cp fhv_trips.csv.gz s3://$1
echo "`date` upload finished"
