#!/bin/bash

basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
nameNodeCount=2
dataNodeCount=6

cd  ${basedir}
source ${basedir}/functions.sh
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

start_node(){
  local name=$1;shift
  if startsWith ${name} "namenode";then
    startNameNode ${name}
  elif startsWith ${name} "datanode";then
    startDataNode ${name}
  else
    :
  fi
  
}

stop_node(){
  local name=$1;shift
  set +e +o pipefail
  docker kill ${name}
  docker rm ${name}
  set -e -o pipefail
}

stop_all_namenode(){
  for name in $(eval "echo namenode{0..$((${nameNodeCount}-1))}");do
    stop_node ${name}
  done
}

stop_all_datanode(){
  for name in $(eval "echo datanode{0..$((${dataNodeCount}-1))}");do
    stop_node ${name}
  done
}

stop_all(){
  stop_all_datanode
  stop_all_namenode
}

restart_node(){
  local name=$1;shift
  stop_node ${name}
  start_node ${name}
}

bootstrap(){
  rm -fr ${basedir}/namenode*_data/*
  rm -fr ${basedir}/datanode*_data/*
  for name in $(eval "echo datanode{0..$((${dataNodeCount}-1))}");do
    data=${basedir:?"undefined"}/${name:?"undefined"}_data
    rm -fr ${data:?"undefined"}/current
    mkdir -p ${data}
  done
  rm -fr ${basedir}/namenode*_logs/*
  rm -fr ${basedir}/datanode*_logs/*
  format
}

start_all_namenode(){
  for name in $(eval "echo namenode{0..$((${nameNodeCount}-1))}");do
    startNameNode $name
  done
}

start_all_datanode(){
  for name in $(eval "echo datanode{0..$((${dataNodeCount}-1))}");do
    startDataNode $name
  done
}

transitionToActive(){
  local name=$1;shift
  checkArgument "name" ${name} "namenode0|namenode1"
  local nn="gra2"
  if isIn ${name} "namenode0";then
    nn="gra2"
  elif isIn ${name} "namenode1";then
    nn="kra2"
  else
    :
  fi
  docker exec -it ${name} /home/hdfs/hadoop/bin/hdfs haadmin -ns grakrabackend -transitionToActive ${nn}  --forceactive
  docker exec -it ${name} /home/hdfs/hadoop/bin/hdfs dfsadmin -safemode leave
}

transitionToStandby(){
  local name=$1;shift
  checkArgument "name" ${name} "namenode0|namenode1"
  local nn="gra2"
  if isIn ${name} "namenode0";then
    nn="gra2"
  elif isIn ${name} "namenode1";then
    nn="kra2"
  else
    :
  fi
  docker exec -it ${name} /home/hdfs/hadoop/bin/hdfs haadmin -ns grakrabackend -transitionToStandby ${nn}
}

getServiceState(){
  local name=$1;shift
  checkArgument "name" ${name} "namenode0|namenode1"
  local nn="gra2"
  if isIn ${name} "namenode0";then
    nn="gra2"
  elif isIn ${name} "namenode1";then
    nn="kra2"
  else
    :
  fi
  docker exec -it ${name} /home/hdfs/hadoop/bin/hdfs haadmin -ns grakrabackend -getServiceState ${nn}
}

failover(){
  local name=$1;shift
  checkArgument "name" ${name} "namenode0|namenode1"
  local nn0="gra2"
  local nn1="kra2"
  if isIn ${name} "namenode0";then
    nn0="gra2"
    nn1="kra2"
  elif isIn ${name} "namenode1";then
    nn0="kra2"
    nn1="gra2"
  else
    :
  fi
  docker exec -it ${name} /home/hdfs/hadoop/bin/hdfs haadmin -ns grakrabackend -getServiceState ${nn0}
  docker exec -it ${name} /home/hdfs/hadoop/bin/hdfs haadmin -ns grakrabackend -getServiceState ${nn1}
  echo "Namenode failover from ${nn1} to ${nn0}"
  docker exec -it ${name} /home/hdfs/hadoop/bin/hdfs haadmin -ns grakrabackend -failover ${nn1} ${nn0}
}

start_all(){
  start_all_namenode
  sleep 5
  transitionToActive "namenode0"
  sleep 5
  start_all_datanode
}

echo "choose cmd:"
cmd=$(selectOption "start" "stop" "restart" "bootstrap" "start_all" "start_all_namenode" "start_all_datanode" "stop_all" "stop_all_namenode" "stop_all_datanode" "transitionToActive" "transitionToStandby" "getServiceState" "failover")

if isIn ${cmd} "start|stop|restart"; then
  echo "choose node:"
  node=$(selectOption $(eval "echo namenode{0..$((${nameNodeCount}-1))} datanode{0..$((${dataNodeCount}-1))}"))
  echo ${cmd}_node ${node}
  confirm
  ${cmd}_node ${node}
elif isIn ${cmd} "transitionToActive|transitionToStandby|failover|getServiceState";then
  echo "choose node:"
  node=$(selectOption $(eval "echo namenode{0..$((${nameNodeCount}-1))}"))
  echo "${cmd} ${node}"
  confirm
  ${cmd} ${node}
else
  echo $cmd
  confirm
  $cmd
fi
