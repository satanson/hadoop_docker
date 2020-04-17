#!/bin/bash

bootstrap=${1};shift
basedir=$(cd $(dirname ${BASH_SOURCE:-$0});pwd)
nameNodeCount=2
dataNodeCount=6

cd  ${basedir}

hadoopRoot=$(readlink -f ${basedir}/../hadoop_all/hadoop)
dockerFlags="--rm -w /home/hdfs -u hdfs -e USER=hdfs --privileged --net static_net0 -v ${PWD}/hosts:/etc/hosts 
	-v ${hadoopRoot}:/home/hdfs/hadoop
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
  -v ${PWD}/start_hdfs_node.sh:/home/hdfs/hadoop/start_hdfs_node.sh
  "
	docker run $flags hadoop_debian:8.8 /home/hdfs/hadoop/start_hdfs_node.sh ${command}
}

format(){
  rm -fr ${PWD}/namenode*_data/*
	flags=' \
  ${dockerFlags} \
  -it \
  --name $name \
  --hostname $name \
  --ip $ip \
  -v ${PWD}/${name}_data:/home/hdfs/hadoop_name_dir \
  -v ${PWD}/${name}_logs:/home/hdfs/hadoop/logs \
  -v ${PWD}/${name}_conf:/home/hdfs/hadoop/etc/hadoop \
  '
  local name=namenode0
	local ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b$name\b/" hosts)
  local namenode0_flags=$(eval "echo ${flags}")

  local name=namenode1
	local ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b$name\b/" hosts)
  local namenode1_flags=$(eval "echo ${flags}")
  
	docker run ${namenode0_flags} hadoop_debian:8.8 bash -c "rm -fr /home/hdfs/hadoop/logs/* && rm -fr /home/hdfs/hadoop_name_dir/* && /home/hdfs/hadoop/bin/hdfs namenode -format -force -nonInteractive"
  docker run ${namenode0_flags} hadoop_debian:8.8 /home/hdfs/hadoop/bin/hdfs namenode -initializeSharedEdits -force -nonInteractive
	docker run ${namenode1_flags} -v ${PWD}/namenode0_data:/home/hdfs/hadoop_name_dir_active hadoop_debian:8.8 cp -r /home/hdfs/hadoop_name_dir_active/current /home/hdfs/hadoop_name_dir/
}

startNameNode(){
	local name=$1;shift
	startNode $name "/home/hdfs/hadoop_name_dir" ${PWD}/${name}_conf namenode
}


startDataNode(){
	local name=$1;shift
	startNode $name "/home/hdfs/hadoop_data_dir" ${PWD}/datanode_conf datanode
}


for name in $(eval "echo namenode{0..$((${nameNodeCount}-1))} datanode{0..$((${dataNodeCount}-1))}");do
  set +e +o pipefail
  docker kill ${name}
  docker rm ${name}
  set -e -o pipefail
done

if [ -n "$bootstrap" ];then
  rm -fr ${basedir}/namenode*_data/*
  #rm -fr ${basedir}/datanode*_data/*
  for name in $(eval "echo datanode{0..$((${dataNodeCount}-1))}");do
    data=${basedir:?"undefined"}/${name:?"undefined"}_data
    rm -fr ${data:?"undefined"}/current
    mkdir -p ${data}
  done
  rm -fr ${basedir}/namenode*_logs/*
  rm -fr ${basedir}/datanode*_logs/*
  format
fi

while : ; do

  for name in $(eval "echo namenode{0..$((${nameNodeCount}-1))}");do
    set +e +o pipefail
    docker kill ${name}
    docker rm ${name}
    set -e -o pipefail
    startNameNode $name
  done

  sleep 10

  if ! docker exec -it namenode0 /home/hdfs/hadoop/bin/hdfs haadmin -ns grakrabackend -transitionToActive gra2 --forceactive;then
    continue
  fi

  if ! docker exec -it namenode0 /home/hdfs/hadoop/bin/hdfs dfsadmin -safemode leave;then
    continue
  fi
  break
done

sleep 5

for name in $(eval "echo datanode{0..$((${dataNodeCount}-1))}");do
  startDataNode $name
done
