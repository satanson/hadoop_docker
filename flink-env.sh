export hadoop_dir=$(readlink -f ${basedir}/../hadoop_all/hadoop)
export flink_dir=$(readlink -f ${basedir}/../hadoop_all/flink)
export HADOOP_CLASSPATH=""
HADOOP_CLASSPATH="${HADOOP_CLASSPATH}:${hadoop_dir}/share/hadoop/common/*"
HADOOP_CLASSPATH="${HADOOP_CLASSPATH}:${hadoop_dir}/share/hadoop/common/lib/*"
HADOOP_CLASSPATH="${HADOOP_CLASSPATH}:${hadoop_dir}/share/hadoop/hdfs/*"
HADOOP_CLASSPATH="${HADOOP_CLASSPATH}:${hadoop_dir}/share/hadoop/hdfs/lib/*"
HADOOP_CLASSPATH="${HADOOP_CLASSPATH}:${hadoop_dir}/share/hadoop/tools/lib/*"
HADOOP_CLASSPATH="${HADOOP_CLASSPATH}:${hadoop_dir}/share/hadoop/yarn/*"
HADOOP_CLASSPATH="${HADOOP_CLASSPATH}:${hadoop_dir}/share/hadoop/yarn/lib/*"

export YARN_CONF_DIR=${basedir}/hadoop_conf_client
export HADOOP_CONF_DIR=${basedir}/hadoop_conf_client 
export FLINK_CONF_DIR=${basedir}/flink_conf
