#!/bin/bash
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
bootstrap=$1;shift

zkRoot=${basedir}/../hadoop_all/zookeeper

set -e -o pipefail
if [ -n "${bootstrap}" ];then
  rm -fr ${basedir:?"undefined"}/zk*_data/*
fi

zkNum=3

for node in $(eval "echo zk{0..$((${zkNum}-1))}") ;do
  set +e +o pipefail
  docker kill ${node}
  docker rm ${node}
  set -e -o pipefail
done

cd ${basedir}

dockerFlags="-tid --rm -w /home/hdfs -u hdfs --privileged --net static_net
  -v ${PWD}/hosts:/etc/hosts -v ${zkRoot}:/home/hdfs/zk -v ${PWD}/zk_conf:/home/hdfs/zk/conf"

for node in $(eval "echo zk{0..$((${zkNum}-1))}") ;do
	ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b$node\b/" hosts)
  flags="
  -v ${PWD}/${node}_data:/home/hdfs/zk_data
  -v ${PWD}/${node}_logs:/home/hdfs/zk/logs
  --name $node
  --hostname $node
  --ip $ip
  "
  myid=${node##zk}
  rm -fr ${PWD}/${node}_logs/*
  mkdir -p ${PWD}/${node}_logs
  docker run ${dockerFlags} ${flags} hadoop_debian:8.8 \
    bash -c "echo ${myid} > /home/hdfs/zk_data/myid && cd /home/hdfs/zk && bin/zkServer.sh start-foreground"
done
