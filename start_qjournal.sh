#!/bin/bash
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
bootstrap=$1;shift

cd ${basedir}
hadoopRoot=$(readlink -f ${basedir}/../hadoop_all/hadoop)
qjournalNum=3

for node in $(eval "echo qjournal{0..$((${qjournalNum}-1))}");do
	docker kill $node
	docker rm $node
done

format(){
  for node in $(eval "echo qjournal{0..$((${qjournalNum}-1))}") ;do
    [ -d ${PWD}/${node}_data ] && rm -fr ${PWD}/${node}_data
    [ -d ${PWD}/${node}_logs ] && rm -fr ${PWD}/${node}_logs
    mkdir -p ${PWD}/${node}_data
    mkdir -p ${PWD}/${node}_logs
  done
}

if [ -n "${bootstrap}" ];then
  format
fi

set -e -o pipefail
dockerFlags="--rm -w /home/hdfs -u hdfs -e USER=hdfs --privileged --net static_net0 -v ${PWD}/hosts:/etc/hosts 
	-v ${hadoopRoot}:/home/hdfs/hadoop
  "

for node in $(eval "echo qjournal{0..$((${qjournalNum}-1))}") ;do
	ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b$node\b/" hosts)
  name=${node}
  mkdir -p ${PWD}/${node}_data
  mkdir -p ${PWD}/${node}_logs

	flags="
  ${dockerFlags}
  -tid
  --name $name
  --hostname $name
  --ip $ip 
  -v ${PWD}/${name}_data:/home/hdfs/journal_dir
  -v ${PWD}/${name}_logs:/home/hdfs/hadoop/logs
  -v ${basedir}/namenode0_conf:/home/hdfs/hadoop/etc/hadoop
  -v ${PWD}/start_hdfs_node.sh:/home/hdfs/hadoop/start_hdfs_node.sh
  "
	# docker run $flags hadoop_debian:8.8 /home/hdfs/hadoop/start_hdfs_node.sh journalnode
	docker run $flags hadoop_debian:8.8 bash -c "/home/hdfs/hadoop/sbin/hadoop-daemon.sh start journalnode && sleep 1000000000"
done
