#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
source ${basedir}/functions.sh
kill_docker_nodes hthriftserver
kill_docker_nodes hregionserver
kill_docker_nodes hmaster
