#!/bin/bash
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
export HADOOP_HOME=$(cd ${basedir}/../hadoop_all/hadoop;pwd)
export HADOOP_CONF_DIR=${basedir}/hadoop_conf_client
export YARN_HOME=$(cd ${basedir}/../hadoop_all/hadoop;pwd)
export YARN_CONF_DIR=${basedir}/hadoop_conf_client
export HBASE_HOME=$(cd ${basedir}/../hadoop_all/hbase;pwd)
export HBASE_CONF_DIR=${basedir}/hbase_client_conf
export HIVE_HOME=$(cd ${basedir}/../hadoop_all/hive23;pwd)
export HIVE_CONF_DIR=${basedir}/hive23_conf
export HCAT_LOG_DIR=${basedir}/hcatlog_log
export JAVA_HOME=/home/grakra/bin/jdk1.8.0_221
export PATH=${JAVA_HOME}/bin:${PATH}
${HIVE_HOME}/hcatalog/sbin/hcat_server.sh --config ${HIVE_CONF_DIR} $*
