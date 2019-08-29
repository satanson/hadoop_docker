#!/bin/bash

t=$1
echo "!desc $t;" > $t.1
./sqlline | sed 's#\[1;32m | \[m##g' | sed '/---/d'  | sed '/TABLE_CAT/d' | sed 's#[1;32m##g' | sed /d'| sed 's#|##g' | awk '{if ($0 ~"PK ") {if (NR != 1) print ")  compression = '\''snappy'\'', UPDATE_CACHE_FREQUENCY=30000, COLUMN_ENCODED_BYTES=0;"; print "create table if not exists "$2"."$3" (\n\"PK\"  VARCHAR PRIMARY KEY"; } else {print ",\""$4"\" ", $6}; }''END{print ")  compression = '\''snappy'\'', UPDATE_CACHE_FREQUENCY=30000, COLUMN_ENCODED_BYTES=0;"}' | sed 's#[m##g'  > $t.sql
rm $t.1
