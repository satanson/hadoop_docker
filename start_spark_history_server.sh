#!/bin/bash
set -e -o pipefail

./hdfs dfs -mkdir -p /tmp/spark-events
./hdfs dfs -mkdir -p /shared/spark-logs

for node in yarnrm{0..1} yarnnm{0..5};do 
  docker exec -it ${node} /home/hdfs/spark/sbin/stop-history-server.sh
  docker exec -it ${node} /home/hdfs/spark/sbin/start-history-server.sh
done
