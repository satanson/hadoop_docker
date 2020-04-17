#!/bin/bash
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
quorums=${1:-"zk0:2181,zk1:2181,zk2:2181"}
${basedir}/../hadoop_all/zookeeper/bin/zkCli.sh -server  ${quorums}
