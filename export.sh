#!/bin/bash
./hbase org.apache.hadoop.hbase.snapshot.ExportSnapshot \
  -snapshot "SYSTEM.test.snapshot.2019.08.30" \
  -copy-from hdfs://grakrabackend/hbase \
  -copy-to hdfs://grakrabackend/hbase2 \
  -mappers 5 \
  -bandwidth 10 \
  -overwrite \
  2>&1 |tee SYSTEM.test.snapshot.2019.08.30.log
