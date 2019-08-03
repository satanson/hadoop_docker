#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname ${BASH_SOURCE:-$0});pwd)
cd ${basedir}
#mvn  clean package -DskipTests=true 
mvn  clean package -DskipTests=true -amd -pl '!phoenix-pig'
#mvn  clean package -Dmaven.test.skip=true -DskipTests=true -amd -pl '!phoenix-pig'
find ./ -name "phoenix*.jar" |xargs -i{} cp '{}' /home/grakra/workspace/hbase_deploy/apache-phoenix-5.0.0-HBase-2.1.4-bin/
find ./ -name "phoenix-5.0.0-HBase-2.1.4-server.jar" |xargs -i{} cp '{}' /home/grakra/workspace/hbase_deploy/hbase-2.1.4/lib/
