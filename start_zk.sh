#!/bin/bash
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

bootstrap=$1;shift

source ${basedir}/functions.sh
zkRoot=${basedir}/../hadoop_all/zookeeper

set -e -o pipefail
if [ -n "${bootstrap}" ];then
  rm -fr ${basedir:?"undefined"}/zk*_data/*
fi

zkNum=3
alivesNum=$(count_docker_nodes '^zk\d+$')
if [ -z "${bootstrap}" -a ${zkNum} -eq ${alivesNum} ];then
  echo "All zookeeper nodes(${zkNum}) are alive";
  exit 0;
fi

kill_docker_nodes '^zk\d+$'

dockerFlags="-tid --rm -w /home/hdfs -u hdfs --privileged --net static_net0
  -v /home/grakra/bin/greys:/home/hdfs/greys
  -v ${HOME}/.greys:/home/hdfs/.greys
  -e ZOO_LOG_DIR=/home/hdfs/zk/logs
  -e ZOO_LOG4J_PROP=INFO,CONSOLE,ROLLINGFILE
  -v ${PWD}/hosts:/etc/hosts -v ${zkRoot}:/home/hdfs/zk -v ${PWD}/zk_conf:/home/hdfs/zk/conf"

for node in $(eval "echo zk{0..$((${zkNum}-1))}") ;do
	ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b$node\b/" hosts)
  flags="
  -v ${PWD}/${node}_data:/home/hdfs/zk_data
  -v ${PWD}/${node}_logs:/home/hdfs/zk/logs
  --name $node
  --hostname $node
  --ip $ip
  "
  myid=${node##zk}
  rm -fr ${PWD}/${node}_logs/*
  mkdir -p ${PWD}/${node}_logs
  docker run ${dockerFlags} ${flags} -e JVMFLAGS="-Djava.io.tmpdir=/tmp  -XX:+UseConcMarkSweepGC -XX:+StartAttachListener" hadoop_debian:8.8 \
    bash -c "echo ${myid} > /home/hdfs/zk_data/myid && cd /home/hdfs/zk && bin/zkServer.sh start-foreground"
done
