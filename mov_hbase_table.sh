#!/bin/bash
move_table(){
  local src_table=${1:?"undefined 'src_table'"};shift
  local dst_table=${1:?"undefined 'dst_table'"};shift
  local snapshot="snapshot.$(date +'%Y%m%d_%H%M%S')"

  hbase shell <<DONE
disable '${src_table}'
snapshot '${src_table}', '${snapshot}'
clone_snapshot '${snapshot}','${dst_table}'
scan '${dst_table}'
delete_snapshot '${snapshot}'
drop '${src_table}'
enable '${dst_table}'
DONE

}

move_table default:SYSTEM.CATALOG SYSTEM:CATALOG
move_table default:SYSTEM.LOG SYSTEM:LOG
move_table default:SYSTEM.SEQUENCE SYSTEM:SEQUENCE
move_table default:SYSTEM.STATS SYSTEM:STATS
move_table default:SYSTEM.FUNCTION SYSTEM:FUNCTION
move_table default:SYSTEM.MUTEX SYSTEM:MUTEX
