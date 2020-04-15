#!/bin/bash
basedir=$(cd $(dirname $(readlink -f ${BASH_SOUECE:-$0}));pwd)
cd ${basedir}

set -e -o pipefail
source ${basedir}/mysqld_ops.sh
source ${basedir}/functions.sh

start_mysql mysql$(ensureNumber ${1:-0})
