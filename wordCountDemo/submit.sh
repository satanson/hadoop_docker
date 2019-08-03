#!/bin/bash
hdfs dfs -rm -r /output
hadoop-yarn jar wc.jar WordCount /user/grakra/data/ /output
