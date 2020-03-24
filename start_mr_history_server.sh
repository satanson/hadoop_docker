#!/bin/bash
set -e -o pipefail

for node in yarnrm{0..1} yarnnm{0..7};do 
  docker exec -it ${node} /home/hdfs/hadoop/sbin/mr-jobhistory-daemon.sh start historyserver
done
