#!/bin/bash
set -e -o pipefail

basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
kafka_dir=$(cd $(readlink -f ${basedir}/../hadoop_all/kafka);pwd)
cd ${basedir}

brokerList=kafka_broker0:9092,kafka_broker1:9092,kafka_broker2:9092,kafka_broker3:9092,kafka_broker4:9092 
${kafka_dir}/bin/kafka-consumer-groups.sh --bootstrap-server ${brokerList} $@
