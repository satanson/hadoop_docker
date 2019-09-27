#!/bin/bash
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
export HADOOP_HOME=$(cd ${basedir}/../hadoop_all/hadoop;pwd)
export HADOOP_CONF_DIR=${basedir}/hadoop_conf_client
export YARN_HOME=$(cd ${basedir}/../hadoop_all/hadoop;pwd)
export YARN_CONF_DIR=${basedir}/hadoop_conf_client
export HBASE_HOME=$(cd ${basedir}/../hadoop_all/hbase;pwd)
export HBASE_CONF_DIR=${basedir}/hbase_client_conf
export HIVE_HOME=$(cd ${basedir}/../hadoop_all/hive;pwd)
export HIVE_CONF_DIR=${basedir}/hive_conf
export HCAT_LOG_DIR=${basedir}/hcatlog_log
${HIVE_HOME}/hcatalog/sbin/hcat_server.sh --config ${HIVE_CONF_DIR} $*
