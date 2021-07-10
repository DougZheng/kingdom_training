#!/bin/bash

ip=doug-hadoop102
case $1 in
"start")
  echo " =================== 启动 hadoop集群 ==================="
  start-all.sh
  echo " --------------- 启动 historyserver ---------------"
  ssh -T $ip <<EOF
  mapred --daemon start historyserver
EOF
;;
"stop")
  echo " =================== 关闭 hadoop集群 ==================="
  echo " --------------- 关闭 historyserver ---------------"
  ssh -T $ip <<EOF
  mapred --daemon stop historyserver
EOF
  stop-all.sh
;;
esac

