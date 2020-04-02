#!/bin/bash
set -e -o pipefail
./hdfs dfs -rm -r /output

pushd /home/grakra/workspace/hadoop/hadoop-mapreduce-project/hadoop-mapreduce-examples
mvn clean package -DskipTests=true -Dmaven.test.skip=true
popd

./submit_mr.sh /home/grakra/workspace/hadoop/hadoop-mapreduce-project/hadoop-mapreduce-examples/target/hadoop-mapreduce-examples-2.7.2.jar org.apache.hadoop.examples.WordCount /user/grakra/data /output
