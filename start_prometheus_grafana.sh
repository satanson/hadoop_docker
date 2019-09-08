#!/bin/bash

basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

PROMETHEUS_HOME=$(cd $(readlink -f ${basedir}/../hadoop_all/prometheus);pwd)
GRAFANA_HOME=$(cd $(readlink -f ${basedir}/../hadoop_all/grafana);pwd)

for c in prometheus grafana;do
	docker kill $c >/dev/null 2>&1
	docker rm $c >/dev/null 2>&1
done

net=static_net
prometheus_ip=192.168.110.211
grafana_ip=192.168.110.212

docker run -tid --net ${net} --ip ${prometheus_ip} \
	--name prometheus --hostname prometheus -p 9090:9090 \
  -v ${PROMETHEUS_HOME}:/home/hdfs/prometheus \
	-v ${basedir}/prometheus_conf:/home/hdfs/prometheus/conf \
  -v ${basedir}/prometheus_data:/home/hdfs/prometheus/data \
  -v ${basedir}/hosts:/etc/hosts \
  hadoop_debian:8.8 \
  /home/hdfs/prometheus/prometheus  --config.file=/home/hdfs/prometheus/conf/prometheus.yml --web.listen-address="0.0.0.0:9090" --storage.tsdb.retention.time=3d --storage.tsdb.path=/home/hdfs/prometheus/data

docker run -d --net ${net} --ip ${grafana_ip} \
  --name grafana -p 3000:3000 \
  -v ${GRAFANA_HOME}:/home/hdfs/grafana \
  -v ${basedir}/grafana_conf:/home/hdfs/grafana/conf \
  -v ${basedir}/grafana_data:/home/hdfs/grafana/data \
  -v ${basedir}/hosts:/etc/hosts \
  hadoop_debian:8.8 \
  bash -c "cd /home/hdfs/grafana && bin/grafana-server"
