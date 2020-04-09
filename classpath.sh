#!/bin/bash
basedir=$(cd $(dirname $(readlink -f ${BASH_SOURCE:-$0}));pwd)
cd ${basedir}

word=${1:?"undefined 'word'"};shift
pid=$(ps -e -o pid,cmd | grep  ${word} | grep -v grep |grep -v classpath.sh | perl -lne 'print $1 if /^\s*(\b\d+\b)/')

if [ -z "${pid}" ];then
  echo "No process match '${word}'"
fi

cat /proc/${pid}/environ | perl -aF'\0' -lne '($cp)=grep /^(CLASSPATH=)/,@F; $cp=substr $cp, length(qq/CLASSPATH=/); print join "\n",split /:/, $cp'
