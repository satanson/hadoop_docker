#!/bin/bash
bootstrap=$1

set -e -o pipefail
basedir=$(cd $(dirname ${BASH_SOURCE:-$0});pwd)
cd ${basedir}

${basedir}/start_zk.sh ${bootstrap}
sleep 5
${basedir}/start_bk.sh ${bootstrap}
sleep 5
${basedir}/start_hdfs.sh ${bootstrap}
