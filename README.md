# Downloading and Scraping NYC Taxi data, including Yellow, Green, Uber and other "For Hire Vehicle" data

This repository builds on the work of [Todd Schneider](http://toddwschneider.com). See the LICENSE for relevant distribution acknowledgements. 

These scripts download, process, and makes available over 1.3 billion taxi and Uber trips originating in New York City. The data is processed in a [PostgreSQL](http://www.postgresql.org/) database, and uses [PostGIS](http://postgis.net/) for spatial calculations, in particular mapping latitude/longitude coordinates to census tracts. The data is then uploaded to both [AWS Redshift](https://aws.amazon.com/redshift/) and [AWS RDS for Postgres](https://aws.amazon.com/rds/postgresql/) via [AWS S3](https://aws.amazon.com/s3/).

The [TLC data](http://www.nyc.gov/html/tlc/html/about/trip_record_data.shtml) comes from the NYC Taxi & Limousine Commission.

## Instructions

##### 0. Set up AWS

###### A) [Launch an AWS EC2 Linux Instance with Ubuntu](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EC2_GetStarted.html)
I recommend anything with a 20 Gigabit network connection as downloading/uploading large data files to/from S3 is made much faster. An `r4.16xlarge` instance works well.

###### B) [Install git](https://www.digitalocean.com/community/tutorials/how-to-install-git-on-ubuntu-16-04) and [clone this repo](https://help.github.com/articles/cloning-a-repository/)

On an Ubuntu instance, clone the repo to the `/home/ubuntu/` directory (the default).

###### C) [Install and Configure the AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/awscli-install-linux.html)
You'll need Python, pip, and the AWSCLI

###### D) [Configure the AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
This step assumes you [have your AWS Access credentials](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html). If you don't, contact your AWS admin.

##### 1. Install [PostgreSQL](http://www.postgresql.org/download/) and [PostGIS](http://postgis.net/install)

It is important to know the Linux distibution you are using before installing. On linux, run `lsb_release -a` from the command line to view your Linux distribution. If you are using Ubuntu, `xenial 16.04.2` and above works well.

For installing on Ubuntu Xenial (16.04), see [this blog post](http://www.paulshapley.com/2016/04/how-to-install-postgresql-95-and.html)

Both are also available via [Homebrew](http://brew.sh/) on Mac OS X

##### 2. Initialize database and set up schema

`./00-initialize_database.sh`

You may need to alter permissions with `chmod 700 -R /home/ubuntu/nyc-taxi-data` to get this to run with no errors. If this script runs with any errors, delete the database entirely with `dropdb nyc-taxi-data` and then run from scratch (otherwise, you'll be re-indexing and wasting disk space).

##### 3. Download raw taxi data 

`./01-download_raw_data.sh`

##### 4. Import taxi data into database and map to census tracts

`./02-import_trip_data.sh`

##### 5. Download and import for-hire vehicle records, including sample Uber data from FiveThirtyEight

`./03-download_raw_uber_data.sh`
<br>
`./04-import_uber_trip_data.sh`
<br>
`./05-import_fhv_trip_data.sh`


##### 6. Export the Yellow and Green trips to csv, then send to S3

First, [Create an AWS S3 bucket](http://docs.aws.amazon.com/AmazonS3/latest/gsg/CreatingABucket.html) to store the trip data. The data needs to go to S3 before it is loaded into Redshift or RDS.

Your S3 bucket is a named varibale to be passed to the bash script. Here, I am sending the data to `s3://taxi.data.v002` so I am passing the argument `taxi.data.v002` but replace as necessary.
<br>
<br>

`.06-send_trips_to_S3.sh taxi.data.v002`

##### 7. Export the FHV trips to csv, then send to S3
 
First, [Create an AWS S3 bucket](http://docs.aws.amazon.com/AmazonS3/latest/gsg/CreatingABucket.html) to store the trip data. The data needs to go to S3 before it is loaded into Redshift or RDS.

Your S3 bucket is a named varibale to be passed to the bash script. Here, I am sending the data to `s3://fhv.data.v001` so I am passing the argument `fhv.data.v001` but replace as necessary.

 <br>

 `./07-send_fhv_trips_to_S3.sh fhv.data.v001`


##### 8. Load the Yellow, Green and FHV data from S3 to Redshift

The arguments you need to pass to this script are as follows:

`./08-load_trips_to_redshift.sh <database password> <database hostname> <database username> <database name> <database port>`

For example:

`./08-load_trips_to_redshift.sh mypw taxi-cluster-ds.clljv8fjklbx.us-west-2.redshift.amazonaws.com myusername mydbname 5439`

[See here](http://docs.aws.amazon.com/redshift/latest/mgmt/connecting-from-psql.html) for more information about connecting to Redshift from psql and how to identify Redshift endpoints, hostnames, etc.


##### 9. Backup the Redshift tables to S3, vacuum and analyze

The arguments you need to pass to this script are as follows:

`./09-final_housekeeping.sh <database password> <database hostname> <database username> <database name> <database port>`

For example:

`./09-final_housekeeping.sh mypw taxi-cluster-ds.clljv8fjklbx.us-west-2.redshift.amazonaws.com myusername mydbname 5439`


## Schema Info

- `trips` table contains all yellow and green taxi trips, plus Uber pickups from April 2014 through September 2014. Each trip has a `cab_type_id`, which references the `cab_types` table and refers to one of `yellow`, `green`, or `uber`. Each trip maps to a census tract for pickup and dropoff
- `nyct2010` table contains NYC census tracts plus the Newark Airport. It also maps census tracts to NYC's official neighborhood tabulation areas
- `taxi_zones` table contains the TLC's official taxi zone boundaries. Starting in July 2016, the TLC no longer provides pickup and dropoff coordinates. Instead, each trip comes with taxi zone pickup and dropoff location IDs
- `uber_trips_2015` table contains Uber pickups from Jan–Jun, 2015. These are kept in a separate table because they don't have specific latitude/longitude coordinates, only location IDs. The location IDs are stored in the `taxi_zone_lookups` table, which also maps them (approximately) to neighborhood tabulation areas
- `fhv_trips` table contains all FHV trip records made available by the TLC
- `central_park_weather_observations` has summary weather data by date

## Other data sources

These are bundled with the repository, so no need to download separately, but:

- Shapefile for NYC census tracts and neighborhood tabulation areas comes from [Bytes of the Big Apple](http://www.nyc.gov/html/dcp/html/bytes/districts_download_metadata.shtml)
- Shapefile for taxi zone locations comes from the TLC
- Mapping of FHV base numbers to names comes from [the TLC](http://www.nyc.gov/html/tlc/html/about/statistics.shtml)
- Central Park weather data comes from the [National Climatic Data Center](http://www.ncdc.noaa.gov/)

## Data issues encountered

- Remove carriage returns and empty lines from TLC data before passing to Postgres `COPY` command
- Some raw data files have extra columns with empty data, had to create dummy columns `junk1` and `junk2` to absorb them
- Two of the `yellow` taxi raw data files had a small number of rows containing extra columns. I discarded these rows
- The official NYC neighborhood tabulation areas (NTAs) included in the shapefile are not exactly what I would have expected. Some of them are bizarrely large and contain more than one neighborhood, e.g. "Hudson Yards-Chelsea-Flat Iron-Union Square", while others are confusingly named, e.g. "North Side-South Side" for what I'd call "Williamsburg", and "Williamsburg" for what I'd call "South Williamsburg". In a few instances I modified NTA names, but I kept the NTA geographic definitions
- The shapefile includes only NYC census tracts. Trips to New Jersey, Long Island, Westchester, and Connecticut are not mapped to census tracts, with the exception of the Newark Airport, for which I manually added a fake census tract
- The Uber 2015 and FHV data uses location IDs instead of latitude/longitude. The location IDs do not exactly overlap with the NYC neighborhood tabulation areas (NTAs) or census tracts, but I did my best to map Uber location IDs to NYC NTAs

## TLC summary statistics

There's a Ruby script in the `tlc_statistics/` folder to import data from the TLC's [summary statistics reports](http://www.nyc.gov/html/tlc/html/about/statistics.shtml):

`ruby import_statistics_data.rb`

## Colophon

All due credit to [Todd Schneider](http://toddwschneider.com/)



