#!/bin/bash

bootstrap=${1};shift
basedir=$(cd $(dirname ${BASH_SOURCE:-$0});pwd)
nameNodeCount=2
dataNodeCount=6

cd  ${basedir}

hadoopRoot=/home/grakra/workspace/hadoop-2.6.0-cdh5.7.0
dockerFlags="--rm -w /root -u root -e USER=root --privileged --net static_net -v ${PWD}/hosts:/etc/hosts 
	-v ${hadoopRoot}:/root/hadoop
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
  -v ${PWD}/${name}_dat:${targetDataDir}
  -v ${PWD}/${name}_log:/root/hadoop/logs
  -v ${confDir}:/root/hadoop/etc/hadoop
  -v ${PWD}/start_hdfs_node.sh:/root/hadoop/start_hdfs_node.sh
  "
	docker run $flags hadoop_debian:8.8 /root/hadoop/start_hdfs_node.sh ${command}
}

format(){
  sudo rm -fr ${PWD}/namenode*_dat/*
	flags=' \
  ${dockerFlags} \
  -it \
  --name $name \
  --hostname $name \
  --ip $ip \
  -v ${PWD}/${name}_dat:/root/hadoop_name_dir \
  -v ${PWD}/${name}_log:/root/hadoop/logs \
  -v ${PWD}/${name}_conf:/root/hadoop/etc/hadoop \
  '
  local name=namenode0
	local ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b$name\b/" hosts)
  local namenode0_flags=$(eval "echo ${flags}")

  local name=namenode1
	local ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b$name\b/" hosts)
  local namenode1_flags=$(eval "echo ${flags}")
  
	docker run ${namenode0_flags} hadoop_debian:8.8 bash -c "rm -fr /root/hadoop/logs/* && rm -fr /root/hadoop_name_dir/* && /root/hadoop/bin/hdfs namenode -format -force -nonInteractive"
  docker run ${namenode0_flags} hadoop_debian:8.8 /root/hadoop/bin/hdfs namenode -initializeSharedEdits -force -nonInteractive
	docker run ${namenode1_flags} -v ${PWD}/namenode0_dat:/root/hadoop_name_dir_active hadoop_debian:8.8 cp -r /root/hadoop_name_dir_active/current /root/hadoop_name_dir/
}

startNameNode(){
	local name=$1;shift
	startNode $name "/root/hadoop_name_dir" ${PWD}/${name}_conf namenode
}


startDataNode(){
	local name=$1;shift
	startNode $name "/root/hadoop_data_dir" ${PWD}/datanode_conf datanode
}


for name in $(eval "echo namenode{0..$((${nameNodeCount}-1))} datanode{0..$((${dataNodeCount}-1))}");do
  set +e +o pipefail
  docker kill ${name}
  docker rm ${name}
  set -e -o pipefail
done

if [ -n "$bootstrap" ];then
  sudo rm -fr ${basedir}/namenode*_dat/*
  #sudo rm -fr ${basedir}/datanode*_dat/*
  for name in $(eval "echo datanode{0..$((${dataNodeCount}-1))}");do
    dat=${basedir:?"undefined"}/${name:?"undefined"}_dat
    sudo rm -fr ${dat:?"undefined"}/current
    mkdir -p ${dat}
  done
  sudo rm -fr ${basedir}/namenode*_log/*
  sudo rm -fr ${basedir}/datanode*_log/*
  format
fi

for name in $(eval "echo namenode{0..$((${nameNodeCount}-1))}");do
  startNameNode $name
done

sleep 5
docker exec -it namenode0 /root/hadoop/bin/hdfs haadmin -ns grakrabackend -transitionToActive gra2 --forceactive
docker exec -it namenode0 /root/hadoop/bin/hdfs dfsadmin -safemode leave
sleep 5

for name in $(eval "echo datanode{0..$((${dataNodeCount}-1))}");do
  startDataNode $name
done
