#!/bin/bash

echo "$(tput setaf 1)`date`,starting housekeeping $(tput sgr0)"

PGPASSWORD=$1 psql -h $2 -U $3 -d $4 -p $5 -f final_housekeeping.sql

echo "$(tput setaf 1)`date`, housekeeping complete  $(tput sgr0)"
