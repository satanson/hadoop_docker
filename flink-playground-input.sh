#!/bin/bash
java -classpath  flink-playground-clickcountjob.jar:/home/grakra/workspace/hadoop_all/flink/lib/* org.apache.flink.playgrounds.ops.clickcount.ClickEventGenerator --bootstrap.servers kafka_broker0:9092,kafka_broker1:9092,kafka_broker2:9092 --topic flink-playground-input
