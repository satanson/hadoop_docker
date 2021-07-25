#!/bin/bash

set -e -o pipefail
basedir=$(cd $(dirname ${BASH_SOURCE:-$0});pwd)
cd ${basedir}

${basedir}/start_zk_bk_hdfs.sh bootstrap

sleep 5
hdfs dfs -mkdir -p /mr_history
hdfs dfs -chmod -R 0777 /mr_history
hdfs dfs -mkdir -p /spark_history
hdfs dfs -chmod -R 0777 /spark_history
hdfs dfs -ls /

${basedir}/start_yarn.sh bootstrap
sleep 5
${basedir}/start_mr_history_server.sh 
${basedir}/start_spark_history_server.sh 
sleep 5

hdfs dfs -mkdir -p /user/grakra/data
hdfs dfs -put *.sh /user/grakra/data/
hdfs dfs -ls /user/grakra/data
hdfs dfs -mkdir -p /tmp/spark-events
hdfs dfs -mkdir -p /shared/spark-logs
hdfs dfs -mkdir -p /shared/spark_jars
hdfs dfs -put /home/grakra/workspace/hadoop_all/spark/jars/* /shared/spark_jars/
hdfs dfs -put /home/grakra/workspace/hadoop_all/spark/spark_libs.zip /shared/
hdfs dfs -put cit-HepTh.txt /user/grakra/data/
