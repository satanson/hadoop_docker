#!/bin/bash

basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
bootstrap=$1;shift
yarnRmCount=2
yarnNmCount=6

cd  ${basedir}

hadoopRoot=${basedir}/../hadoop_all/hadoop
sparkRoot=${basedir}/../spark-2.4.3-bin-hadoop2.6

dockerFlags="--rm -w /root -u root -e USER=root --privileged --net static_net -v ${PWD}/hosts:/etc/hosts 
	-v ${hadoopRoot}:/root/hadoop
  -v ${sparkRoot}:/root/spark
  -v ${basedir}/spark_conf:/root/spark/conf
  -v ${basedir}/spark_logs:/root/spark/logs
  "

for node in $(eval "echo yarnrm{0..$((${yarnRmCount}-1))} yarnnm{0..$((${yarnNmCount}-1))}");do
	docker kill $node
	docker rm $node
done

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
  -v ${PWD}/${name}_dat:${targetDataDir}
  -v ${PWD}/${name}_log:/root/hadoop/logs
  -v ${confDir}:/root/hadoop/etc/hadoop
  -v ${PWD}/start_yarn_node.sh:/root/hadoop/start_yarn_node.sh
  "
	docker run $flags hadoop_debian:8.8 /root/hadoop/start_yarn_node.sh ${command}
}

start_yarnrm(){
	local name=$1;shift
	startNode $name "/root/yarnrm_data" ${PWD}/${name}_conf resourcemanager
}


start_yarnnm(){
	local name=$1;shift
	startNode $name "/root/yarnnm_data" ${PWD}/${name}_conf nodemanager
}


for name in $(eval "echo yarnrm{0..$((${yarnRmCount}-1))} yarnnm{0..$((${yarnNmCount}-1))}");do
  set +e +o pipefail
  docker kill ${name}
  docker rm ${name}
  set -e -o pipefail
done

if [ -n "$bootstrap" ];then
  sudo rm -fr ${PWD}/yarnrm*_dat/*
  sudo rm -fr ${PWD}/yarnnm*_dat/*
  sudo rm -fr ${PWD}/yarnrm*_log/*
  sudo rm -fr ${PWD}/yarnnm*_log/*
fi

for name in $(eval "echo yarnrm{0..$((${yarnRmCount}-1))}");do
  start_yarnrm $name
done

sleep 5
for name in $(eval "echo yarnnm{0..$((${yarnNmCount}-1))}");do
  start_yarnnm $name
done
