#!/bin/bash
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}
hadoopDir=$(cd ${basedir}/../hadoop_all/hadoop;pwd)
${hadoopDir}/bin/hadoop --config ${basedir}/hadoop_conf_client/ $@
