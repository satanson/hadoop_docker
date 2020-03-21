#!/bin/bash
basedir=$(cd $(dirname ${BASH_SOURCE:-$0});pwd)
cd ${basedir}

set -e -o pipefail
source ${basedir}/functions.sh
source ${basedir}/mysqld_ops.sh

mysqldNum=3
mysqlNum=3

echo "mysqld or mysql: "
bin=$(selectOption "mysqld" "mysql")
if isIn ${bin} "mysqld";then
  echo "cmd: "
  cmd=$(selectOption "restart" "bootstrap" "stop" "start")
  node=$(selectOption $(eval "echo mysqld{0..$((${mysqldNum}-1))}"))
  if isIn ${cmd} "restart|bootstrap|stop|start";then
    echo "exec: ${cmd}_${bin} ${node}"
    confirm
    ${cmd}_${bin} ${node}
  fi
elif isIn ${bin} "mysql"; then
  echo "cmd: "
  cmd=$(selectOption "start")
  node=$(selectOption $(eval "echo mysql{0..$((${mysqlNum}-1))}"))
  if isIn ${cmd} "start";then
    echo "exec: ${cmd}_${bin} ${node}"
    confirm
    ${cmd}_${bin} ${node}
  fi
fi
