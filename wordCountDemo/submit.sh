#!/bin/bash
hdfs dfs -rm -r /output
yarn jar wc.jar WordCount /user/grakra/data/ /output
