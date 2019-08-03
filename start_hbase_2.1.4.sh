#!/bin/bash

bootstrap=${1};shift
basedir=$(cd $(dirname ${BASH_SOURCE:-$0});pwd)
hmasterCount=2
hregionserverCount=6
hthriftserverCount=2

cd  ${basedir}

hbaseRoot=/home/grakra/workspace/hbase_deploy/hbase-2.1.4
dockerFlags="--rm -w /root -u root -e USER=root --privileged --net static_net -v ${PWD}/hosts:/etc/hosts 
	-v ${hbaseRoot}:/root/hbase
  "

startNode(){
	local name=$1;shift
	local hbaseTmpDir=$1;shift
  local confDir=$1;shift
  local command=$*

	local ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b$name\b/" hosts)

	flags="
  ${dockerFlags}
  -tid
  --name $name
  --hostname $name
  --ip $ip 
  -v ${PWD}/${name}_tmp:${hbaseTmpDir}
  -v ${PWD}/${name}_logs:/root/hbase/logs
  -v ${confDir}:/root/hbase/conf
  "
	docker run $flags hadoop_debian:8.8 /root/hbase/bin/hbase ${command}
}

startHMaster(){
	local name=$1;shift
	startNode $name "/root/hbase_tmp" ${PWD}/hbase_conf master start
}

startHRegionServer(){
	local name=$1;shift
	startNode $name "/root/hbase_tmp" ${PWD}/hbase_conf regionserver start
}

startHThriftServer(){
	startNode $name "/root/hbase_tmp" ${PWD}/hbase_conf thrift -m 150 -w 1000 -q 2000 --port 9400 --infoport 9405  start
}

for name in $(eval "echo hmaster{0..$((${hmasterCount}-1))} hregionserver{0..$((${hregionserverCount}-1))} hthriftserver{0..$((${hthriftserverCount}-1))}");do
  set +e +o pipefail
  docker kill ${name}
  docker rm ${name}
  set -e -o pipefail
done

if [ -n "$bootstrap" ];then
  hdfs dfs -rm -r /hbase
  docker exec -it zk0 /root/zk/bin/zkCli.sh -server localhost:2181 rmr /hbase
  sudo rm -fr ${basedir}/hmaster*_tmp/*
  sudo rm -fr ${basedir}/hregionserver*_tmp/*
  sudo rm -fr ${basedir}/hthriftserver*_tmp/*
  sudo rm -fr ${basedir}/hmaster*_logs/*
  sudo rm -fr ${basedir}/hregionserver*_logs/*
  sudo rm -fr ${basedir}/hthriftserver*_logs/*
  for name in $(eval "echo hmaster{0..$((${hmasterCount}-1))} hregionserver{0..$((${hregionserverCount}-1))} hthriftserver{0..$((${hthriftserverCount}-1))}");do
    dat=${basedir:?"undefined"}/${name:?"undefined"}_tmp
    logs=${basedir:?"undefined"}/${name:?"undefined"}_logs
    mkdir -p ${dat}
    mkdir -p ${logs}
  done
fi

for name in $(eval "echo hmaster{0..$((${hmasterCount}-1))}");do
  startHMaster $name
done

sleep 5

for name in $(eval "echo hregionserver{0..$((${hregionserverCount}-1))}");do
  startHRegionServer $name
done

for name in $(eval "echo hthriftserver{0..$((${hthriftserverCount}-1))}");do
  startHThriftServer $name
done
