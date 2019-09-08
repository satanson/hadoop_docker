#!/bin/bash
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
bootstrap=$1;shift
cd ${basedir}

zkRoot=${basedir}/../hadoop_all/zookeeper

set -e -o pipefail
source ${basedir}/functions.sh

bootstrap(){
  rm -fr ${basedir:?"undefined"}/zk*_data/*
}

if [ -n "${bootstrap}" ];then
  bootstrap
fi

zkNum=3
dockerFlags="-tid --rm -w /home/hdfs -u hdfs --privileged --net static_net
  -v ${PWD}/hosts:/etc/hosts -v ${zkRoot}:/home/hdfs/zk -v ${PWD}/zk_conf:/home/hdfs/zk/conf"

stop_node(){
  local node=${1:?"missing 'node'"}
  set +e +o pipefail
  docker kill ${node}
  docker rm ${node}
  set -e -o pipefail
}

start_node(){
  local node=${1:?"missing 'node"};shift
  local ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b$node\b/" hosts)
  local flags="
  -v ${PWD}/${node}_data:/home/hdfs/zk_data
  -v ${PWD}/${node}_logs:/home/hdfs/zk/logs
  --name $node
  --hostname $node
  --ip $ip
  "
  local myid=${node##zk}
  rm -fr ${PWD}/${node}_logs/*
  mkdir -p ${PWD}/${node}_logs
  docker run ${dockerFlags} ${flags} hadoop_debian:8.8 \
    bash -c "echo ${myid} > /home/hdfs/zk_data/myid && cd /home/hdfs/zk && bin/zkServer.sh start-foreground"
}

restart_node(){
  local node=${1:?"missing 'node"};shift
  stop_node ${node}
  start_node ${node}
}

stop_all(){
  for node in $(eval "echo zk{0..$((${zkNum}-1))}") ;do
    stop_node ${node}
  done
}

start_all(){
  for node in $(eval "echo zk{0..$((${zkNum}-1))}") ;do
    start_node ${node}
  done
}

restart_all(){
  for node in $(eval "echo zk{0..$((${zkNum}-1))}") ;do
    stop_node ${node}
    start_node  ${node}
  done
}

echo "choose cmd:"
cmd=$(selectOption "start" "stop" "restart" "bootstrap" "start_all" "stop_all" "restart_all")

if isIn ${cmd} "start|stop|restart";then
  echo "choose node:"
  node=$(selectOption $(eval "echo zk{0..$((${zkNum}-1))}"))
  echo ${cmd}_node ${node}
  confirm
  ${cmd}_node ${node}
else
  echo ${cmd}
  confirm
  ${cmd}
fi
