#!/usr/bin/env bash
set -x -e -o pipefail

export LANG=en_US.UTF-8
ulimit -c 10485760

command=${1:?"namenode|datanode|journalnode"};shift
if [ "x${command}x" != "xnamenodex" -a "x${command}x" != "xdatanodex" -a "x${command}x" != "xjournalnodex" ];then
  echo "command should be namenode|datanode|journalnode" >&2
  exit 1
fi

basedir=/home/hdfs/hadoop
cd $basedir

bin=`cd bin; pwd`

DEFAULT_LIBEXEC_DIR="$bin"/../libexec
HADOOP_LIBEXEC_DIR=${HADOOP_LIBEXEC_DIR:-$DEFAULT_LIBEXEC_DIR}
. $HADOOP_LIBEXEC_DIR/hadoop-config.sh

#default value
hadoopScript="$HADOOP_PREFIX"/bin/hadoop

if [ -f "${HADOOP_CONF_DIR}/hadoop-env.sh" ]; then
  . "${HADOOP_CONF_DIR}/hadoop-env.sh"
fi

if [ "$HADOOP_IDENT_STRING" = "" ]; then
  export HADOOP_IDENT_STRING="$USER"
fi

# get log directory
if [ "$HADOOP_LOG_DIR" = "" ]; then
  export HADOOP_LOG_DIR="$HADOOP_PREFIX/logs"
fi

if [ ! -w "$HADOOP_LOG_DIR" ] ; then
  mkdir -p "$HADOOP_LOG_DIR"
  chown $HADOOP_IDENT_STRING $HADOOP_LOG_DIR
fi

if [ "$HADOOP_PID_DIR" = "" ]; then
  HADOOP_PID_DIR=/tmp
fi

# some variables
export HADOOP_LOGFILE=hadoop-$HADOOP_IDENT_STRING-$command-$HOSTNAME.log
export HADOOP_ROOT_LOGGER=${HADOOP_ROOT_LOGGER:-"INFO,RFA"}
export HADOOP_SECURITY_LOGGER=${HADOOP_SECURITY_LOGGER:-"INFO,RFAS"}
export HDFS_AUDIT_LOGGER=${HDFS_AUDIT_LOGGER:-"INFO,NullAppender"}
log=$HADOOP_LOG_DIR/hadoop-$HADOOP_IDENT_STRING-$command-$HOSTNAME.out
pid=$HADOOP_PID_DIR/hadoop-$HADOOP_IDENT_STRING-$command.pid

[ -w "$HADOOP_PID_DIR" ] ||  mkdir -p "$HADOOP_PID_DIR"

if [ -f $pid ]; then
  if kill -0 `cat $pid` > /dev/null 2>&1; then
    echo $command running as process `cat $pid`.  Stop it first. >> "$log"
    exit 1
  fi
fi

echo starting $command, logging to $log >> "$log"
cd "$HADOOP_PREFIX"

echo write pid $$ to $pid >> "$log"
echo $$ > $pid

if [ -z "$HADOOP_HDFS_HOME" ]; then
  hdfsScript="$HADOOP_PREFIX"/bin/hdfs
else
  hdfsScript="$HADOOP_HDFS_HOME"/bin/hdfs
fi

echo started: `date` >> "$log"
$hdfsScript --config $HADOOP_CONF_DIR $command "$@" >> "$log" 2>&1 < /dev/null
