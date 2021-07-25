#!/bin/bash
set -e -o pipefail
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
test  ${basedir} == ${PWD}

prestoRoot=$(cd $(readlink -f ${basedir}/../hadoop_all/presto-server);pwd)
prestoDockerRoot=/home/hdfs/presto-server

presto_coordinator_list=$(perl -lne 'print $1 if /^\s*\d+(?:\.\d+){3}\s+(presto_coordinator\d+)\s*$/' ${PWD}/hosts )
presto_worker_list=$(perl -lne 'print $1 if /^\s*\d+(?:\.\d+){3}\s+(presto_worker\d+)\s*$/' ${PWD}/hosts )

dockerFlags="-tid --rm -u hdfs -w ${prestoDockerRoot} --privileged --net static_net0 -v ${PWD}/hosts:/etc/hosts \
  -v ${prestoRoot}:${prestoDockerRoot}"

stop_node(){
  local name=$1;shift
  set +e +o pipefail
  docker kill ${name}
  docker rm ${name}
  set -e -o pipefail
}

## es-fe

stop_presto_node_args(){
  local node=${1:?"undefined 'presto node'"};shift
  local finalize=${1:-"false"}
  stop_node ${node}
  if [ "x${finalize}x" != 'xfalsex' ];then
    datadir=${node}_data
    logdir=${node}_logs
    for dir in $(eval "echo ${node}_{data,logs}");do
      [ -d "${dir}" ] && rm -fr ${dir:?"undefined"}
    done
  fi
}

start_presto_node_args(){
  local node=${1:?"undefined 'node'"};shift
  local bootstrap=${1:-"false"};shift;
  local ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /^\\d+(\\.\\d+){3}\\s+\\b$node\\b/" hosts)

  local nodeType=$(perl -e "print \$1 if qq/${node}/=~/^([^\d]+)\d*$/")
  for d in data logs conf;do
    d=${node}_${d}
    if [ ! -d ${d} ]; then
      red_print "Node directory ${d} not exists" >&2
      exit 1
    fi
  done

  local flags="
  -v ${PWD}/${node}_data:/home/hdfs/presto_data
  -v ${PWD}/${node}_logs:/home/hdfs/presto_logs
  -v ${PWD}/${node}_conf:${prestoDockerRoot}/etc
  --name $node
  --hostname $node
  --ip $ip
  "

  [ -d "${node}_logs" ] && rm -fr ${node:?"undefined"}_logs
  if [ "x${bootstrap}x" != "xfalsex" ];then
    [ -d "${PWD}/${node}_data" ] &&  rm -fr ${PWD}/${node}_data/*
  fi
  mkdir -p ${PWD}/${node}_logs
  mkdir -p ${PWD}/${node}_data

  # run docker
  green_print docker run ${dockerFlags} ${flags} hadoop_debian:8.8 -- ${prestoDockerRoot}/bin/launcher run --verbose
  docker run ${dockerFlags} ${flags} hadoop_debian:8.8 -- ${prestoDockerRoot}/bin/launcher run --verbose
}

stop_presto_coordinator(){
  stop_presto_node_args ${1:?"missing 'node'"} "false"
}

destroy_presto_coordinator(){
  stop_presto_node_args ${1:?"missing 'node'"} "true"
}

do_all(){
  local func=${1:?"missing 'func'"}
  set -- $(perl -e "print qq/\$1 \$2/ if qq/${func}/ =~ /^(\\w+)_all_(\\w+)\$/")
  local cmd=${1:?"missing 'cmd'"};shift
  local nodeType=${1:?"missing 'nodeType'"};shift
  green_print "BEGIN: ${func}"
  for node in $(eval "echo \${${nodeType}_list}"); do
    green_print "run: ${cmd}_${nodeType} ${node}"
    ${cmd}_${nodeType} ${node}
  done
  green_print "END: ${func}"
}

stop_all_presto_coordinator(){ do_all ${FUNCNAME};}
destroy_all_presto_coordinator(){ do_all ${FUNCNAME};}


bootstrap_presto_coordinator(){
  start_presto_node_args ${1:?"undefined 'node'"} "true"
}

bootstrap_all_presto_coordinator(){ do_all ${FUNCNAME};}

start_presto_coordinator(){
  start_presto_node_args ${1:?"undefined 'node'"} "false"
}

start_all_presto_coordinator(){ do_all ${FUNCNAME};}

restart_presto_coordinator(){
  local node=${1:?"undefined 'presto_coordinator'"};shift
  stop_presto_coordinator ${node}
  start_presto_coordinator ${node}
}

restart_all_presto_coordinator(){ do_all ${FUNCNAME};}

stop_presto_worker() {
  stop_presto_node_args ${1:?"missing 'node'"} "false"
}

destroy_presto_worker() {
  stop_presto_node_args ${1:?"missing 'node'"} "true"
}

bootstrap_presto_worker() {
  start_presto_node_args ${1:?"missing 'node'"} "true"
}


start_presto_worker(){
  start_presto_node_args ${1:?"missing 'node'"} "false"
}

restart_presto_worker(){
  local node=$1;shift
  stop_node ${node}
  start_presto_worker ${node}
}

stop_all_presto_worker(){ do_all ${FUNCNAME};}
destroy_all_presto_worker(){ do_all ${FUNCNAME};}
bootstrap_all_presto_worker(){ do_all ${FUNCNAME};}
start_all_presto_worker(){ do_all ${FUNCNAME};}
restart_all_presto_worker(){ do_all ${FUNCNAME};}

# cluster
start_presto_cluster(){
  start_all_presto_coordinator
  start_all_presto_worker
}

stop_presto_cluster(){
  stop_all_presto_worker
  stop_all_presto_coordinator
}

restart_presto_cluster(){
  restart_all_presto_worker
  restart_all_presto_coordinator
}

bootstrap_presto_cluster(){
  stop_presto_cluster
  bootstrap_all_presto_coordinator
  bootstrap_all_presto_worker
}

destroy_presto_cluster(){
  destroy_all_presto_worker
  destroy_all_presto_coordinator
}
