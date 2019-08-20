#!/bin/bash
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

killAll(){
  local comp=$(docker ps -a --format "{{.Names}}"|perl -lne 'chomp;push @a,$_}{print join ":", @a')
  local kw=${1:?"missing 'keyword'"};shift
  for p in $(selectWord ${comp} ":" ${kw});do
    echo kill2docker $p ${kw}
    kill2docker $p ${kw}
  done
}
