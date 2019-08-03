#!/bin/bash
basedir=$(cd $(dirname ${BASH_SOURCE:-$0});pwd)
cd ${basedir}

dockerFlags="--name mysqld --net static_net --ip 192.168.110.100 --rm -v ${PWD}/mysqld:/root/mysqld -v ${PWD}/my.cnf:/etc/mysql/my.cnf -u root -w /root"
image=mysql:8.0

docker kill mysqld

bootstrap=$1;shift
if [ -n "${bootstrap}" ];then
  docker run -it ${dockerFlags} ${image} /bin/bash -c "rm -fr /root/mysqld/data/* && /usr/sbin/mysqld --user root --initialize"
  docker run -dit ${dockerFlags} ${image} mysqld_safe --user root
  docker exec -it mysqld mysql -S /root/mysqld/run/mysqld.sock -u root 
fi

#docker run -it ${dockerFlags} ${image} bash -x -c "mkdir -p /root/mysql/run && mysqld_safe --user root"
