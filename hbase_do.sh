#!/bin/bash


bootstrap=${1};shift
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
hmasterCount=2
hregionserverCount=6
hthriftserverCount=2

cd  ${basedir}
source ${basedir}/functions.sh

hbaseRoot=$(readlink -f ${basedir}/../hadoop_all/hbase)

dockerFlags="--rm -w /home/hdfs -u hdfs -e USER=hdfs --privileged --net static_net0 
  --security-opt seccomp:unconfined
  --cap-add ALL
  --ipc private
  -v ${PWD}/hosts:/etc/hosts 
  -v ${JAVA_HOME}:/opt/jdk
	-v ${hbaseRoot}:/home/hdfs/hbase
  -v /home/grakra/bin/greys:/home/hdfs/btrace
  -v ${HOME}/.greys:/home/hdfs/.greys
  "

startNode(){
	local name=$1;shift
  local confDir=$1;shift
  local command=$*

	local ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b$name\b/" hosts)
  mkdir -p ${PWD}/${name}_systmp/
  #rm -fr ${PWD}/${name}_logs/*
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

stop_all(){
  stop_all_regionserver
  stop_all_master
}

stop_all_master(){
  for name in $(eval "echo hmaster{0..$((${hmasterCount}-1))}");do
    stop_node ${name}
  done
}

stop_all_regionserver(){
  for name in $(eval "echo hregionserver{0..$((${hregionserverCount}-1))}");do
    stop_node ${name}
  done
}

stop_node(){
  local name=${1:?"missing 'name'"};shift
  set +e +o pipefail
  docker kill ${name}
  docker rm ${name}
  set -e -o pipefail
}

bootstrap(){
  ./hdfs dfs -rm -r /hbase
  docker exec -it zk0 /root/zk/bin/zkCli.sh -server localhost:2181 rmr /hbase
  rm -fr ${basedir}/hmaster*_tmp/*
  rm -fr ${basedir}/hregionserver*_tmp/*
  rm -fr ${basedir}/hthriftserver*_tmp/*
  for name in $(eval "echo hmaster{0..$((${hmasterCount}-1))} hregionserver{0..$((${hregionserverCount}-1))}");do
    data=${basedir:?"undefined"}/${name:?"undefined"}_tmp
    logs=${basedir:?"undefined"}/${name:?"undefined"}_logs
    mkdir -p ${data}
    mkdir -p ${logs}
  done
}

start_all_master(){
  for name in $(eval "echo hmaster{0..$((${hmasterCount}-1))}");do
    startHMaster $name
  done
}

start_all_regionserver(){
  for name in $(eval "echo hregionserver{0..$((${hregionserverCount}-1))}");do
    startHRegionServer $name
  done
}
start_all(){
  start_all_master
  start_all_regionserver
}

restart_node(){
  local name=${1:?"missing 'name'"};shift
  stop_node ${name}
  start_node ${name}
}

start_node(){
  local name=${1:?"missing 'name'"};shift
  if startsWith ${name} "hmaster"; then
    startHMaster ${name}
  elif startsWith ${name} "hregionserver";then
    startHRegionServer ${name}
  else
    :
  fi
}

echo "choose cmd:"
cmd=$(selectOption "start" "stop" "restart" "bootstrap" "start_all" "start_all_master" "start_all_regionserver" "stop_all" "stop_all_master" "stop_all_regionserver")

if isIn ${cmd} "start|stop|restart"; then
  echo "choose node:"
  node=$(selectOption $(eval "echo hmaster{0..$((${hmasterCount}-1))} hregionserver{0..$((${hregionserverCount}-1))}"))
  echo ${cmd}_node ${node}
  confirm
  ${cmd}_node ${node}
else
  echo $cmd
  confirm
  $cmd
fi
