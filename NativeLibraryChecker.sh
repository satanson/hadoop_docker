#!/bin/bash
script=$(readlink -f ${BASE_SOURCE:-$0})
basedir=$(cd $(dirname ${script});pwd)
${basedir}/hbase org.apache.hadoop.util.NativeLibraryChecker
