#!/bin/bash

bootstrap=${1};shift
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
hmasterCount=2
hregionserverCount=6
hthriftserverCount=2

cd  ${basedir}

hadoopRoot=$(readlink -f ${basedir}/../hadoop_all/hadoop)
hbaseRoot=$(readlink -f ${basedir}/../hadoop_all/hbase)

dockerFlags="--rm -w /home/hdfs -u hdfs -e USER=hdfs --privileged --net static_net0 
  --security-opt seccomp:unconfined
  --cap-add ALL
  --ipc private
  -v ${PWD}/hosts:/etc/hosts 
  -v ${JAVA_HOME}:/opt/jdk
	-v ${hbaseRoot}:/home/hdfs/hbase
  -v ${BTRACE_HOME}:/home/hdfs/btrace
  -v ${HOME}/.greys:/home/hdfs/.greys
  -v ${hadoopRoot}:/home/hdfs/hadoop
  -v /usr/lib:/usr/lib
  "

startNode(){
	local name=$1;shift
  local confDir=$1;shift
  local command=$*

	local ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b$name\b/" hosts)
  mkdir -p ${PWD}/${name}_systmp/
  rm -fr ${PWD}/${name}_logs/*
  mkdir -p ${PWD}/${name}_logs
  mkdir -p ${PWD}/${name}_tmp

	flags="
  ${dockerFlags}
  -tid
  --name $name
  --hostname $name
  --ip $ip 
  -v ${PWD}/${name}_tmp:/home/hdfs/hbase_tmp
  -v ${PWD}/${name}_systmp:/tmp
  -v ${PWD}/${name}_logs:/home/hdfs/hbase/logs
  -v ${confDir}:/home/hdfs/hbase/conf
  "
	docker run $flags hadoop_debian:8.8 /bin/bash -c "/home/hdfs/hbase/bin/hbase-daemon.sh start ${command} && sleep 100000"
}

startHMaster(){
	local name=$1;shift
	startNode $name ${PWD}/hbase_conf master
}

startHRegionServer(){
	local name=$1;shift
	startNode $name ${PWD}/hbase_conf regionserver
}

startHThriftServer(){
	startNode $name ${PWD}/hbase_conf thrift -m 150 -w 1000 -q 2000 --port 9400 --infoport 9405  start
}

for name in $(eval "echo hmaster{0..$((${hmasterCount}-1))} hregionserver{0..$((${hregionserverCount}-1))} hthriftserver{0..$((${hthriftserverCount}-1))}");do
  set +e +o pipefail
  docker kill ${name}
  docker rm ${name}
  set -e -o pipefail
done

if [ -n "$bootstrap" ];then
  ./hdfs dfs -rm -r /hbase
  docker exec -it zk0 /home/hdfs/zk/bin/zkCli.sh -server localhost:2181 rmr /hbase
  rm -fr ${basedir}/hmaster*_tmp/*
  rm -fr ${basedir}/hregionserver*_tmp/*
  rm -fr ${basedir}/hthriftserver*_tmp/*
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

#for name in $(eval "echo hthriftserver{0..$((${hthriftserverCount}-1))}");do
#  startHThriftServer $name
#done
