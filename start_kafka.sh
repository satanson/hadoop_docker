#!/bin/bash
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)

cd ${basedir}
source ${basedir}/functions.sh

kafkaRoot=$(readlink -f ${basedir}/../hadoop_all/kafka)
kafkaBrokerNum=5
kafkaConfigTemplate=${basedir}/kafka_config

bootstrap=${1:-""}

kill_docker_nodes "^kafka-manager$"
kill_docker_nodes 'kafka_broker'

format(){
  for node in $(eval "echo kafka_broker{0..$((${kafkaBrokerNum}-1))}") ;do
    [ -d ${PWD}/${node}_data ] && rm -fr ${PWD}/${node}_data/*
    [ -d ${PWD}/${node}_logs ] && rm -fr ${PWD}/${node}_logs/*
  done

  set +e +o pipefail
  ${basedir}/zkCli.sh <<'DONE'
deleteall /brokers
deleteall /kafka-manager
quit
DONE
  set -e -o pipefail
}

if [ -n "${bootstrap}" ];then
  format
fi

timeout=$(perl -lne 'print $1 if /^\s*zookeeper\.connection\.timeout\.ms\s*=\s*(\b\d+\b)/' ${kafkaConfigTemplate}/server.properties)
sleep $((timeout/1000*4/3))

set -e -o pipefail
dockerFlags="--rm -w /home/hdfs -u hdfs --privileged --net static_net0 \
  -e LOG_DIR=/home/hdfs/kafka_logs \
  -e JMX_PORT=10000 \
  -v ${PWD}/hosts:/etc/hosts \
  -v ${kafkaRoot}:/home/hdfs/kafka"
  

${basedir}/start_zk.sh

for node in $(eval "echo kafka_broker{0..$((${kafkaBrokerNum}-1))}") ;do
	ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b$node\b/" hosts)
  mkdir -p ${PWD}/${node}_data
  mkdir -p ${PWD}/${node}_logs

  id=${node##kafka_broker}

  rm -fr ${PWD:?"undefined 'PWD'"}/${node:?"undefined 'node'"}_logs/*log*
  flags="
  -v ${PWD}/${node}_data:/home/hdfs/kafka_data
  -v ${PWD}/${node}_logs:/home/hdfs/kafka_logs
  -v ${kafkaConfigTemplate}:/home/hdfs/kafka/config
  --name $node
  --hostname $node
  --ip $ip
  "

  docker run -tid ${dockerFlags} ${flags} hadoop_debian:8.8 \
    bash -c "cd /home/hdfs/kafka && bin/kafka-server-start.sh config/server.properties \
    --override broker.id=${id} \
    --override kafka.logs.dir=/home/hdfs/kafka_logs"
done

ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /^\s*\d+(\.\d+){3}\s*\bkafka-manager\b/" hosts)
zkQuorums=zk0:2181,zk1:2181,zk2:2181
docker run -dit --net static_net0 --ip ${ip} --rm --name kafka-manager \
  -v ${PWD}/hosts:/etc/hosts \
  -e ZK_HOSTS=${zkQuorums} \
  kafkamanager/kafka-manager
