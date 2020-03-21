#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
${basedir}/hdfs dfs -mkdir -p /tmp
${basedir}/hdfs dfs -mkdir -p /user/hive/warehouse
${basedir}/hdfs dfs -chmod g+w  /tmp
${basedir}/hdfs dfs -chmod g+w  /user/hive/warehouse
docker exec -it mysqld0 /bin/bash -c 'mysql -h localhost -P3306 -uroot --connect-expired-password -p123456 -e "create database if not exists hive" '
${basedir}/schematool -dbType mysql -initSchema
