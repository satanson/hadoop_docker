#!/usr/bin/env bash

export LANG=en_US.UTF-8
ulimit -c 10485760

command=$1;shift
if [ "x${command}x" != "xresourcemanagerx" -a "x${command}x" != "xnodemanagerx" ];then
  echo "command should be resourcemanager|nodemanager" >&2
  exit 1
fi

basedir=/home/hdfs/hadoop
USER=hdfs

cd $basedir

bin=`cd bin; pwd`

DEFAULT_LIBEXEC_DIR="$bin"/../libexec
HADOOP_LIBEXEC_DIR=${HADOOP_LIBEXEC_DIR:-$DEFAULT_LIBEXEC_DIR}
. $HADOOP_LIBEXEC_DIR/yarn-config.sh

if [ -f "${YARN_CONF_DIR}/yarn-env.sh" ]; then
  . "${YARN_CONF_DIR}/yarn-env.sh"
fi
if [ "$YARN_IDENT_STRING" = "" ]; then
  export YARN_IDENT_STRING="$USER"
fi
# get log directory
if [ "$YARN_LOG_DIR" = "" ]; then
  export YARN_LOG_DIR="$HADOOP_YARN_HOME/logs"
fi
if [ ! -w "$YARN_LOG_DIR" ] ; then
  mkdir -p "$YARN_LOG_DIR"
  chown $YARN_IDENT_STRING $YARN_LOG_DIR
fi
if [ "$YARN_PID_DIR" = "" ]; then
  YARN_PID_DIR=/tmp
fi

# some variables
export YARN_LOGFILE=yarn-$YARN_IDENT_STRING-$command-$HOSTNAME.log
export YARN_ROOT_LOGGER=${YARN_ROOT_LOGGER:-INFO,RFA}
log=$YARN_LOG_DIR/yarn-$YARN_IDENT_STRING-$command-$HOSTNAME.out
pid=$YARN_PID_DIR/yarn-$YARN_IDENT_STRING-$command.pid

[ -w "$YARN_PID_DIR" ] || mkdir -p "$YARN_PID_DIR"

if [ -f $pid ]; then
  if kill -0 `cat $pid` > /dev/null 2>&1; then
    echo $command running as process `cat $pid`.  Stop it first.
    exit 1
  fi
fi

echo write pid $$ to $pid
echo $$ > $pid

echo started: `date` >> "$log"
exec  "$HADOOP_YARN_HOME"/bin/yarn --config $YARN_CONF_DIR $command "$@" >> "$log" 2>&1 < /dev/null
