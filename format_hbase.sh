#!/bin/bash
docker exec -it zk0 /root/zk/bin/zkCli.sh -server localhost:2181 rmr /hbase
docker exec -it zk0 /root/zk/bin/zkCli.sh -server localhost:2181 ls /
hdfs dfs -rm -r /hbase
hdfs dfs -ls /
