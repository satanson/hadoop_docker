#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname ${BASH_SOURCE:-$0});pwd)
cd ${basedir}

${basedir}/stop_hdfs.sh
${basedir}/stop_bk.sh
${basedir}/stop_zk.sh
