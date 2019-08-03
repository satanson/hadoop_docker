#!/bin/bash
basedir=$(cd $(dirname ${BASH_SOURCE:-$0});pwd)
bootstrap=$1;shift

set -e -o pipefail
if [ -n "${bootstrap}" ];then
  sudo rm -fr ${basedir:?"undefined"}/zk*_data/*
fi

zkNum=3

for node in $(eval "echo zk{0..$((${zkNum}-1))}") ;do
  set +e +o pipefail
  docker kill ${node}
  docker rm ${node}
  set -e -o pipefail
done

cd ${basedir}
zkRoot=/home/grakra/workspace/zookeeper-3.4.8
dockerFlags="-tid --rm -w /root -u root --privileged --net static_net
  -v ${PWD}/hosts:/etc/hosts -v ${zkRoot}:/root/zk -v ${PWD}/zk_conf:/root/zk/conf"

for node in $(eval "echo zk{0..$((${zkNum}-1))}") ;do
	ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b$node\b/" hosts)
  flags="
  -v ${PWD}/${node}_data:/root/zk_data
  --name $node
  --hostname $node
  --ip $ip
  "
  myid=${node##zk}
  docker run ${dockerFlags} ${flags} hadoop_debian:8.8 \
    bash -c "echo ${myid} > /root/zk_data/myid && cd /root/zk && bin/zkServer.sh start-foreground"
done
