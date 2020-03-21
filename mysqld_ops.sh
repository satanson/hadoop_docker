#!/bin/bash
basedir=$(cd $(dirname ${BASH_SOURCE:-$0});pwd)
test ${PWD} = ${basedir}

set -e -o pipefail
dockerFlags=" --rm -v ${PWD}/hosts:/etc/hosts -v ${PWD}/mysqld_conf:/etc/mysql  -u root -w /root"
image=mysql:8.0

stop_mysqld(){
  local node=${1:?"undefined 'node'"};shift
  set +e +o pipefail
  docker kill ${node}
  docker rm ${node}
  set -e -o pipefail
}

bootstrap_mysqld(){
  local node=${1:?"undefined 'node'"};shift
  local ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b${node}\b/" hosts)
  local extraFlags="--name ${node} --hostname ${node} --net static_net0 --ip ${ip} -v ${PWD}/${node}_data:/root/mysqld_data"

  stop_mysqld ${node}
  docker run -it ${dockerFlags} ${extraFlags} ${image} /bin/bash -c "rm -fr /root/mysqld_data/* && mysqld  --defaults-file=/etc/mysql/my.cnf  --initialize" >&1 |tee mysqld.initialize.log

  local password=$(perl -ne 'print $1 if /A temporary password is generated for root\@localhost: (\S+)\s*$/' mysqld.initialize.log)

cat >alter_password.sql << DONE
alter user 'root'@'localhost' identified by '123456';
flush privileges;
create user 'root'@'192.168.128.0/255.255.240.0';
# drop user 'root'@'192.168.128.0/255.255.240.0';
create user 'foobar'@'192.168.128.0/255.255.240.0';
# drop user 'foobar'@'192.168.128.0/255.255.240.0';
set password for 'root'@'192.168.128.0/255.255.240.0' = '123456';
set password for 'foobar'@'192.168.128.0/255.255.240.0' = '123456';
grant all on *.* to 'root'@'192.168.128.0/255.255.240.0';
# revoke insert, update on test.* from 'root'@'192.168.128.0/255.255.240.0';
grant all on *.* to 'foobar'@'192.168.128.0/255.255.240.0';
# revoke all on test.* from 'root'@'192.168.128.0/255.255.240.0';
flush privileges;
select user,host,authentication_string from mysql.user;
show grants;
DONE

  docker run -dit ${dockerFlags} ${extraFlags} -v ${PWD}/alter_password.sql:/root/alter_password.sql ${image} /bin/bash -c "mysqld --defaults-file=/etc/mysql/my.cnf -u root"
  echo bootstrap password: ${password}
  docker exec -it ${node} /bin/bash -c "mysql -h localhost -P3306 --connect-expired-password  -uroot -p  <alter_password.sql"
  docker kill ${node}

  docker run -dit ${dockerFlags} ${extraFlags} ${image} /bin/bash -c "mysqld --defaults-file=/etc/mysql/my.cnf  -u root"
  local cliNode=mysql${node##mysqld};
  local cliIp=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b${cliNode}\b/" hosts)
  local cliExtraFlags="--name ${cliNode} --hostname ${cliNode} --net static_net0 --ip ${cliIp}"

cat >test.sql <<- DONE
create database if not exists test;
use test;
create table if not exists id_gen (id integer auto_increment primary key);
insert into id_gen values (),(),(),(),(),(),(),();
select * from id_gen;
DONE
  
  sleep 2
  set +e +o pipefail
  docker kill ${cliNode}
  docker run -it ${dockerFlags} ${cliExtraFlags} -v ${PWD}/test.sql:/root/test.sql ${image}  /bin/bash -c "mysql -h ${ip} -P3306 -uroot --connect-expired-password -p123456 <test.sql"
  docker kill ${node}
  set -e -o pipefail
}

start_mysqld(){
  local node=${1:?"undefined 'node'"};shift
  local ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b${node}\b/" hosts)
  local extraFlags="--name ${node} --hostname ${node} --net static_net0 --ip ${ip} -v ${PWD}/${node}_data:/root/mysqld_data"
  docker run -dit ${dockerFlags} ${extraFlags} ${image} /bin/bash -c "mysqld --defaults-file=/etc/mysql/my.cnf -u root"
}

restart_mysqld(){
  local node=${1:?"undefined 'node'"};shift
  stop_mysqld ${node}
  start_mysqld ${node}
}

start_mysql(){
  local node=${1:?"undefined 'node'"};shift
  local mysqldNode=mysqld${node##mysql}
  test "x${node}x" != "x${mysqldNode}x"
  local ip=$(perl -aF/\\s+/ -ne "print \$F[0] if /\b${node}\b/" hosts)
  local extraFlags="--name ${node} --hostname ${node} --net static_net0 --ip ${ip}"
  docker run -it ${dockerFlags} ${extraFlags} ${image} /bin/bash -c "mysql -h ${mysqldNode} -P3306 -uroot --connect-expired-password -p123456"
}
