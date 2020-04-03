#!/bin/bash
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
bootstrap=$1;shift

cd ${basedir}
bkRoot=$(readlink -f ${basedir}/../hadoop_all/bookkeeper-server)
bkNum=5
bkAutoRecoveryNum=1

for node in $(eval "echo bk{0..$((${bkNum}-1))}");do
	docker kill $node
	docker rm $node
done

for node in $(eval "echo bk_autorecovery{0..$((${bkAutoRecoveryNum}-1))}");do
	docker kill $node
	docker rm $node
done

set -e -o pipefail
dockerFlags="--rm -w /home/hdfs -u hdfs --privileged --net static_net0 -v ${PWD}/hosts:/etc/hosts -v ${bkRoot}:/home/hdfs/bk -v ${PWD}/bk_conf:/home/hdfs/bk/conf"

bootstrap(){
    # create zkLedgersRootPath i.e /bk/ledgers
    zkLedgersRootPath=$(perl -lne 'print $1 if/^\s*zkLedgersRootPath\s*=\s*(\S+)/' bk_conf/bk_server.conf)
    docker exec -it zk0 /home/hdfs/zk/bin/zkCli.sh -server zk0:2181 rmr ${zkLedgersRootPath} 
    for dir in $(perl -e "@comp=split m|/|, qq|${zkLedgersRootPath}|; print join qq|\n|,map{join qq|/|, @comp[0..\$_]} 1..\$#comp");do
      docker exec -it zk0 /home/hdfs/zk/bin/zkCli.sh -server zk0:2181 create ${dir} ""
    done
    rm -fr ${basedir}/bk*_data/*
}

if [ -n "${bootstrap}" ];then
  bootstrap
fi

for node in $(eval "echo bk{0..$((${bkNum}-1))}") ;do
	ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b$node\b/" hosts)
  mkdir -p ${PWD}/${node}_data
  mkdir -p ${PWD}/${node}_logs
  rm -fr ${PWD:?"undefined 'PWD'"}/${node:?"undefined 'node'"}_logs/*log*
  flags="
  -v ${PWD}/${node}_data:/home/hdfs/bk_data
  -v ${PWD}/${node}_logs:/home/hdfs/bk_logs
  --name $node
  --hostname $node
  --ip $ip
  "

  if [ "x${node}x" = "xbk0x" ];then
    set +e +o pipefail
    inited=/home/hdfs/bk_data/metaformat.done
    docker run -ti ${dockerFlags} ${flags} hadoop_debian:8.8 \
      bash -c "[ -f ${inited} ] || (cd /home/hdfs/bk && /home/hdfs/bk/bin/bookkeeper shell metaformat -force -nonInteractive && touch ${inited})"
    sleep 2
    docker kill bk0
    docker rm bk0
    set -e -o pipefail
    sleep 5
  fi

  docker run -tid ${dockerFlags} ${flags} hadoop_debian:8.8 \
    bash -c "cd /home/hdfs/bk && bin/bookkeeper bookie"
done

for node in $(eval "echo bk_autorecovery{0..$((${bkAutoRecoveryNum}-1))}") ;do
	ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b$node\b/" hosts)
  mkdir -p ${PWD}/${node}_data
  mkdir -p ${PWD}/${node}_logs
  rm -fr ${PWD:?"undefined 'PWD'"}/${node:?"undefined 'node'"}_logs/*log*
  flags="
  -v ${PWD}/${node}_data:/home/hdfs/bk_data
  -v ${PWD}/${node}_logs:/home/hdfs/bk_logs
  --name $node
  --hostname $node
  --ip $ip
  "
  docker run -tid ${dockerFlags} ${flags} hadoop_debian:8.8 \
    bash -c "cd /home/hdfs/bk && bin/bookkeeper autorecovery"
done
