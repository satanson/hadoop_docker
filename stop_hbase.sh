#!/bin/bash
bootstrap=$1

set -e -o pipefail
basedir=$(cd $(dirname ${BASH_SOURCE:-$0});pwd)
cd ${basedir}

comp=$(docker ps -a --format "{{.Names}}"|perl -lne 'chomp;push @a,$_}{print join ":", @a')

echo ${comp}

selectWord(){
  local words=${1:?"undefined 'words'"};shift
  local sep=${1:?"undefined 'sep'"};shift
  local kw=${1:?"undefined 'kw'"};shift
  perl -e "print (join qq{\\t}, (grep /${kw}/, (split qq/${sep}/, qq/${words}/)))"
}

kill2docker(){
  local p=${1:?"undefined 'p'"};shift
  local kw=${1:?"undefined 'p'"};shift
  docker exec -it $p /bin/bash -c "ps -C java -o pid,cmd|perl -lne 'qx(kill -2 \$1) if /^\\s*\\b(\\d+)\\b.*${kw}/i'"
}

for p in $(selectWord ${comp} ":" "hthriftserver");do
  kill2docker $p "hthriftserver"
done

for p in $(selectWord ${comp} ":" "hmaster");do
  kill2docker $p "hmaster"
done

for p in $(selectWord ${comp} ":" "hregionserver");do
  kill2docker $p "hregionserver"
done