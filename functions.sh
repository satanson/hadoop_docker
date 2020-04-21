#!/bin/bash
selectWord(){
  local words=${1:?"undefined 'words'"};shift
  local sep=${1:?"undefined 'sep'"};shift
  local kw=${1:?"undefined 'kw'"};shift
  perl -e "print (join qq{\\t}, (grep /^${kw}/, (split qq/${sep}/, qq/${words}/)))"
}

selectOption(){
  test $# -gt 0
  select opt in $*;do
    echo ${opt}
    break;
  done
}

selectHostList(){
  local dir=${1:?"missing 'dir'"};shift
  dir=${dir%%/}
  local oldshopt=$(set +o)
  set -e -o pipefail
  test -d ${dir}
  local n=$(ls ${dir}|wc -l)
  test ${n} -gt 0
  local selectList=$(ls ${dir}|xargs -i{} basename '{}')
  local chosed=""
  select opt in ${selectList};do
    chosed=${opt}
    break;
  done
  set +vx;eval "${oldshopt}"
  echo ${dir}/${chosed}
}

confirm(){
  echo -n "Are your sure[yes/no]: "
    while : ; do
      read input
      input=$(perl -e "print qq/\L${input}\E/")
      case ${input} in
        y|ye|yes)
          break
          ;;
        n|no)
          echo "operation is cancelled!!!"
          exit 0
          ;;
        *)
          echo -n "invalid choice, choose again!!! [yes|no]: "
          ;;
      esac
    done
}

checkArgument(){
  local name=${1:?"missing 'name'"};shift
  local arg=${1:?"missing 'arg'"};shift
  local alternatives=${1:?"missing 'alternatives'"};shift

  if [ -z ${alternatives} ];then
    echo "ERROR: empty alternatives for '${name}', value='${arg}'" >&2
    exit 1
  fi

  if test x$(perl -e "print qq/${alternatives}/=~/^\w+(?:\|\w+)*$/")x != x1x;then
    echo "ERROR: alternatives must be in format word1|word2|word3..., name='${name}', value='${arg}', alternatives='${alternatives}" >&2
    exit 2
  fi

  if test x$(perl -e "print qq/$arg/=~/^(?:${alternatives})$/")x != x1x; then
    echo "ERROR: unmatched argument, name='${name}', value='${arg}', alternatives='${alternatives}'" >&2
    exit 1
  fi
}

isIn(){
  local arg=${1:?"missing 'arg'"};shift
  local alternatives=${1:?"missing 'alternatives'"};shift

  if [ -z ${alternatives} ];then
    echo "ERROR: empty alternatives, value=${arg}" >&2
    exit 1
  fi

  if test x$(perl -e "print qq/${alternatives}/=~/^\w+(?:\|\w+)*$/")x != x1x;then
    echo "ERROR: alternatives must be in format word1|word2|word3..., value='${arg}', alternatives='${alternatives}" >&2
    exit 2
  fi

  if test x$(perl -e "print qq/$arg/=~/^(?:${alternatives})$/")x != x1x; then
    return 1
  else
    return 0
  fi
}

startsWith(){
  local arg=${1:?"missing 'arg'"};shift
  local prefix=${1:?"missing 'prefix'"};shift
  if [ "x${arg##${prefix}}x" = "x${arg}x" ];then
    return 1
  else
    return 0
  fi
}

endsWith(){
  local arg=${1:?"missing 'arg'"};shift
  local suffix=${1:?"missing 'prefix'"};shift
  if [ "x${arg%%${suffix}}x" = "x${arg}x" ];then
    return 1
  else
    return 0
  fi
}

ensureNumber(){
  local num=${1:?"missing arg:'num'"};shift
  local isNum=$(perl -e "print qq/ok/ if qq(${num}) =~ /^\\d+$/")
  if [ -z ${isNum} ];then
    echo "Illegal number: '${num}'" >&2
    exit 1
  fi
  echo ${num}
}

kill_docker_nodes(){
  local pattern=${1:?"missing 'pattern'"};shift
  set +e +o pipefail
  for node in $(docker ps --format {{.Names}} --filter name=${pattern});do
    echo docker kill ${node}
    docker kill ${node}
  done
  for node in $(docker ps --format {{.Names}} --filter name=${pattern});do
    docker rm ${node}
  done
  set -e -o pipefail
}

count_docker_nodes(){
  docker ps --format {{.Names}} --filter name=${1:?"missing 'pattern'"}|wc -l
}
