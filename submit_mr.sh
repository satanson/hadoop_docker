#!/bin/bash

HADOOP_CONF_DIR=/home/grakra/workspace/hadoop_docker/hadoop_conf_client
YARN_CONF_DIR=/home/grakra/workspace/hadoop_docker/hadoop_conf_client
HADOOP_HOME=/home/grakra/workspace/hadoop_all/hadoop

CLASSPATH=${HADOOP_CONF_DIR}
jardir="
share/hadoop/common
share/hadoop/common/lib
share/hadoop/hdfs
share/hadoop/hdfs/lib
share/hadoop/httpfs/tomcat/bin
share/hadoop/httpfs/tomcat/lib
share/hadoop/kms/tomcat/bin
share/hadoop/kms/tomcat/lib
share/hadoop/mapreduce
share/hadoop/mapreduce/lib
share/hadoop/mapreduce/lib-examples
share/hadoop/tools/lib
share/hadoop/yarn
share/hadoop/yarn/lib"

for d in $(echo ${jardir});do
  CLASSPATH="${CLASSPATH}:${HADOOP_HOME}/${d}/*"
done

mainJar=${1:?"undefined jar"};shift
mainClass=${1:?"undefined class"};shift

CLASSPATH=${CLASSPATH}:${mainJar}

java -cp ${CLASSPATH} \
  ${mainClass} $*
