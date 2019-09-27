#!/bin/bash
set -x
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

JAVA_HOME=/home/grakra/ssd/jdk
PATH=${JAVA_HOME}/bin:${PATH}


t=${1:?"missing 't'"};shift

echo "!desc $t" | ${basedir}/sqlline | \
       perl -lpe 's#(\x{1b}\[1;32m\s*)|(\s*\x{1b}\[m)##g' | \
       perl -lne 'print unless /(---)|(TABLE_CAT)/' | \
       perl -lne 'print unless /\x{08}\x{08}/' | \
       perl -lne 'print unless /jdbc:phoenix/' | \
       perl -pe 's#\|##g' | \
       perl -aF'\s+' -lne '
        if (/\PK\b/) {
          if($. != 1 ){
            print qq#) compression=\x{27}snappy\x{27},UPDATE_CACHE_FREQUENCY=30000, COLUMN_ENCODED_BYTES=0;#
          };
          print qq#create table if not exists $F[1].$F[2] (\n"PK" VARCHAR PRIMARY KEY#
        } else {
          print qq#,"$F[3]" $F[5]#
        }
        END {
          print qq#) compression=\x{27}snappy\x{27},UPDATE_CACHE_FREQUENCY=30000, COLUMN_ENCODED_BYTES=0;#
        }' |tee ${t}.sql
