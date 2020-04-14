#!/bin/bash
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
export SPARK_CONF_DIR=${basedir}/spark_conf_client
export TERM=xterm-color
export HIVE_SERVER2_THRIFT_PORT=10000
export HIVE_SERVER2_THRIFT_BIND_HOST=0.0.0.0
${basedir}/../hadoop_all/spark/sbin/start-thriftserver.sh $@
