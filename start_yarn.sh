#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
source ${basedir}/functions.sh

bootstrap=$1
yarnRmCount=2
yarnNmCount=8

cd  ${basedir}

hadoopRoot=$(cd $(readlink -f ${basedir}/../hadoop_all/hadoop);pwd)
sparkRoot=$(cd $(readlink -f ${basedir}/../hadoop_all/spark);pwd)

dockerFlags="--rm -w /home/hdfs -u hdfs -e USER=hdfs --privileged --net static_net0 -v ${PWD}/hosts:/etc/hosts 
	-v ${hadoopRoot}:/home/hdfs/hadoop
  -v ${sparkRoot}:/home/hdfs/spark
  -v ${basedir}/spark_conf:/home/hdfs/spark/conf
  -v ${basedir}/spark_logs:/home/hdfs/spark/logs
  -v /home/grakra/bin/greys:/home/hdfs/greys
  -v ${HOME}/.greys:/home/hdfs/.greys
  "

startNode(){
	local name=$1;shift
	local targetDataDir=$1;shift
  local confDir=$1;shift
  local command=$1;shift


	local ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b$name\b/" hosts)

	flags="
  ${dockerFlags}
  -tid
  --name $name
  --hostname $name
  --ip $ip 
  -v ${PWD}/${name}_data:${targetDataDir}
  -v ${PWD}/${name}_logs:/home/hdfs/hadoop/logs
  -v ${confDir}:/home/hdfs/hadoop/etc/hadoop
  -v ${PWD}/start_yarn_node.sh:/home/hdfs/hadoop/start_yarn_node.sh
  "
	docker run $flags hadoop_debian:8.8 /home/hdfs/hadoop/start_yarn_node.sh ${command}
}

start_yarnrm(){
	local name=$1;shift
	startNode $name "/home/hdfs/yarnrm_data" ${PWD}/${name}_conf resourcemanager
}


start_yarnnm(){
	local name=$1;shift
	startNode $name "/home/hdfs/yarnnm_data" ${PWD}/${name}_conf nodemanager
}

kill_docker_nodes '^yarnrm\d+$'
kill_docker_nodes '^yarnnm\d+$'

format(){
  docker exec -it zk0 /home/hdfs/zk/bin/zkCli.sh -server localhost:2181 rmr /yarn-leader-election
  docker exec -it zk0 /home/hdfs/zk/bin/zkCli.sh -server localhost:2181 rmr /yarnrm_rmstore
  rm -fr ${PWD}/yarnrm*_data/*
  rm -fr ${PWD}/yarnnm*_data/*
  rm -fr ${PWD}/yarnrm*_logs/*
  rm -fr ${PWD}/yarnnm*_logs/*
}

if [ -n "$bootstrap" ];then
  format
fi

for name in $(eval "echo yarnrm{0..$((${yarnRmCount}-1))}");do
  start_yarnrm $name
done

sleep 5
for name in $(eval "echo yarnnm{0..$((${yarnNmCount}-1))}");do
  start_yarnnm $name
done
