#! /bin/bash

ips=(doug-hadoop103)
case $1 in
"start"){
  for ip in ${ips[@]}
  do
    echo " --------启动 $ip 消费flume-------"
    ssh -T $ip <<EOF
    if [[ \`ps -ef | grep kafka-flume-hdfs | grep -v grep | awk '{print \$2}'\` != "" ]]; then
      echo $ip: kafka-flume-hdfs already running.
      exit
    fi
    nohup flume-ng agent -n a1 -f \$FLUME_HOME/conf/kafka-flume-hdfs.conf -Dflume.root.logger=INFO,LOGFILE >/usr/local/flume/apache-flume-1.9.0-bin/log2.txt 2>&1 &
EOF
  done
};;
"stop"){
  for ip in ${ips[@]}
  do
    echo " --------停止 $ip 消费flume-------"
    ssh -T $ip <<EOF
    ps -ef | grep kafka-flume-hdfs | grep -v grep | awk '{print \$2}' | xargs -n1 kill
EOF
  done
};;
"status"){
  for ip in ${ips[@]}
  do
    echo " --------查看 $ip 采集flume-------"
    ssh -T $ip <<EOF
    echo pid: \`ps -ef | grep kafka-flume-hdfs | grep -v grep | awk '{print \$2}'\`
EOF
  done
};;
esac

