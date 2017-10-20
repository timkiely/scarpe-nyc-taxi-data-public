#!/bin/bash

echo "`date` creating trips csv"
psql nyc-taxi-data -c "copy (select * from trips) to '/home/ubuntu/scrape-taxi-data/trips.csv' delimiter '|'";
echo "`date` yellow and green trips csv done"

echo "`date` starting zip job"
gzip trips.csv
echo "`date` zip job finished"

echo "`date` starting upload"
aws s3 cp trips.csv.gz s3://$1
echo "`date` upload finished"
