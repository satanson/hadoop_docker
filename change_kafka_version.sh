#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

source ${basedir}/functions.sh
kafkaParentDir="/home/grakra/workspace/hadoop_all"

kafkaVersions="
${kafkaParentDir}/kafka_2.11-0.10.2.2
${kafkaParentDir}/kafka_2.11-1.1.1
${kafkaParentDir}/kafka_2.12-2.5.0
"

echo "kafka version: "
targetVersion=$(selectOption $(echo ${kafkaVersions}|perl -aF/\\s+/ -lne 'print join qq/ /, grep {$_} map {/kafka_\d+\.\d+-([\d\.]+)$/; $1} @F'))
kafkaLink=/home/grakra/workspace/hadoop_all/kafka
[ -L ${kafkaLink} ] && rm ${kafkaLink:?"undefined"}
for version in $(echo ${kafkaVersions});do
  if endsWith ${version} ${targetVersion};then
    bash -x -c "ln -sf ${version} ${kafkaLink}"
    break
  fi
done

if [ ! -L ${kafkaLink} ];then
  echo "Target version '${targetVersion}' not exists" >&2
  exit 1
fi

${basedir}/start_kafka.sh bootstrap
${basedir}/kafka_create_topic buzz:1:1
${basedir}/kafka_create_topic foobar:10:3
