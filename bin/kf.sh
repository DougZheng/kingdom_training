#!/bin/bash

ips=(doug-hadoop101 doug-hadoop102 doug-hadoop103)

case $1 in
"start"){
  for ip in ${ips[@]}
  do
    echo " --------启动 $ip Kafka-------"
    ssh -T $ip << EOF
kafka-server-start.sh -daemon \$KAFKA_HOME/config/server.properties 
EOF
  done
};;
"stop"){
  for ip in ${ips[@]}
  do
    echo " --------停止 $ip Kafka-------"
    ssh -T $ip << EOF
kafka-server-stop.sh stop
EOF
  done
};;
esac
