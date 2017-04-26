#!/bin/bash

echo "$(tput setaf 1)`date`,starting load to redshift $(tput sgr0)"
#echo "`date` starting load to redshift"

PGPASSWORD=$1 psql -h $2 -U $3 -d $4 -p $5 -f load_trips_to_redshift.sql

#echo "`date` load to redshift complete"
echo "$(tput setaf 1)`date`,load to redshift complete  $(tput sgr0)"
