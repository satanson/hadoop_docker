#!/bin/bash
set -e -o pipefail

./hdfs dfs -mkdir -p /tmp/spark-events
./hdfs dfs -mkdir -p /shared/spark-logs
./hdfs dfs -mkdir -p hdfs://grakrabackend/spark_history

for node in yarnrm{0..1} yarnnm{0..7};do 
  docker exec -it ${node} /home/hdfs/spark/sbin/stop-history-server.sh
  docker exec -it ${node} /home/hdfs/spark/sbin/start-history-server.sh
done
