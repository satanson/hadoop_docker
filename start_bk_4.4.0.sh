#!/bin/bash
basedir=$(cd $(dirname ${BASH_SOURCE:-$0});pwd)
bootstrap=$1;shift

cd ${basedir}
bkRoot=/home/grakra/workspace/bookkeeper-server-4.4.0
bkNum=3

for node in $(eval "echo bk{0..$((${bkNum}-1))}");do
	docker kill $node
	docker rm $node
done

set -e -o pipefail
dockerFlags="--rm -w /root -u root --privileged --net static_net -v ${PWD}/hosts:/etc/hosts -v ${bkRoot}:/root/bk -v ${PWD}/bk_conf:/root/bk/conf"

bootstrap(){
    # create zkLedgersRootPath i.e /bk/ledgers
    zkLedgersRootPath=$(perl -lne 'print $1 if/^\s*zkLedgersRootPath\s*=\s*(\S+)/' bk_conf/bk_server.conf)
    docker exec -it zk0 /root/zk/bin/zkCli.sh -server zk0:2181 rmr ${zkLedgersRootPath} 
    for dir in $(perl -e "@comp=split m|/|, qq|${zkLedgersRootPath}|; print join qq|\n|,map{join qq|/|, @comp[0..\$_]} 1..\$#comp");do
      docker exec -it zk0 /root/zk/bin/zkCli.sh -server zk0:2181 create ${dir} ""
    done
    sudo rm -fr ${basedir}/bk*_dat/*
}

if [ -n "${bootstrap}" ];then
  bootstrap
fi

for node in $(eval "echo bk{0..$((${bkNum}-1))}") ;do
	ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b$node\b/" hosts)
  mkdir -p ${PWD}/${node}_dat
  mkdir -p ${PWD}/${node}_logs
  flags="
  -v ${PWD}/${node}_dat:/root/bk_dat
  -v ${PWD}/${node}_logs:/root/bk_logs
  --name $node
  --hostname $node
  --ip $ip
  "

  if [ "x${node}x" = "xbk0x" ];then
    set +e +o pipefail
    inited=/root/bk_dat/metaformat.done
    docker run -ti ${dockerFlags} ${flags} hadoop_debian:8.8 \
      bash -c "[ -f ${inited} ] || (cd /root/bk && /root/bk/bin/bookkeeper shell metaformat -force -nonInteractive && touch ${inited})"
    sleep 2
    docker kill bk0
    docker rm bk0
    set -e -o pipefail
    sleep 5
  fi

  docker run -tid ${dockerFlags} ${flags} hadoop_debian:8.8 \
    bash -c "cd /root/bk && bin/bookkeeper bookie"
done
