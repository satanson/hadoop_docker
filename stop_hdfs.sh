#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
source ${basedir}/functions.sh
kill_docker_nodes datanode
kill_docker_nodes namenode
