#!/bin/bash
bootstrap=$1

set -e -o pipefail
basedir=$(cd $(dirname ${BASH_SOURCE:-$0});pwd)
cd ${basedir}

${basedir}/start_zk_3.4.8.sh ${bootstrap}
sleep 5
${basedir}/start_bk_4.4.0.sh ${bootstrap}
sleep 5
${basedir}/start_hdfs_2.6.sh ${bootstrap}
