#!/bin/bash
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
set -e -o pipefail
bash  ${basedir}/../hadoop_all/hadoop/bin/yarn --config ${basedir}/hadoop_conf_client/ $@
