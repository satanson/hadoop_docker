#!/bin/bash
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
set +e +o pipefail
${basedir}/hdfs dfs -rm -r /user/hive23/warehouse
set -e -o pipefail
${basedir}/hdfs dfs -mkdir -p /tmp
${basedir}/hdfs dfs -mkdir -p /user/hive23/warehouse
${basedir}/hdfs dfs -chmod g+w  /tmp
${basedir}/hdfs dfs -chmod g+w  /user/hive23/warehouse
docker exec -it mysqld0 /bin/bash -c 'mysql -h localhost -P3306 -uroot --connect-expired-password -p123456 -e "drop database if exists hive23" '
${basedir}/schematool23 -dbType mysql -initSchema
