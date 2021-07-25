#!/bin/bash

./flink run -m yarn-cluster -d -p 4  flink-playground-clickcountjob.jar --bootstrap.servers kafka_broker0:9092,kafka_broker1:9092,kafka_broker2:9092 --checkpointing --event-time --input-topic flink-playground-input   --output-topic flink-playground-output
