#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname ${BASH_SOURCE:-$0});pwd)
cd ${basedir}
hbase_deploy=${basedir}/../hbase_deploy
mkdir -p ${hbase_deploy}
tgz=${basedir}/hbase-assembly/target/hbase-2.1.4-bin.tar.gz
rm ${tgz}
mvn clean
mvn -T 4C -nsu -o -DskipTests -Dmaven.test.skip=true package assembly:single
cp ${tgz} ${hbase_deploy}/
pushd ${hbase_deploy}
[ -d hbase-2.1.4-bin ] && rm -fr hbase-2.1.4-bin
tar xzf hbase-2.1.4-bin.tar.gz
cp htrace-core-3.1.0-incubating.jar hbase-2.1.4/lib/
cp apache-phoenix-5.0.0-HBase-2.0-bin/phoenix-5.0.0-HBase-2.0-server.jar hbase-2.1.4/lib/
popd
