#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
${basedir}/hdfs dfs -mkdir -p /tmp/hive12
${basedir}/hdfs dfs -mkdir -p /user/hive12/warehouse
${basedir}/hdfs dfs -chmod g+w  /tmp/hive12
${basedir}/hdfs dfs -chmod g+w  /user/hive12/warehouse
docker exec -it mysqld1 /bin/bash -c 'mysql -h localhost -P3306 -uroot --connect-expired-password -p123456 -e "create database if not exists hive" '
${basedir}/schematool12 -dbType mysql -initSchema
