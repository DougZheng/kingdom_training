#! /bin/bash

ips=(doug-hadoop101 doug-hadoop102)
case $1 in
"start"){
  for ip in ${ips[@]}
  do
    echo " --------启动 $ip 采集flume-------"
    ssh -T $ip <<EOF
    if [[ \`ps -ef | grep file-flume-kafka | grep -v grep | awk '{print \$2}'\` != "" ]]; then
      echo $ip: file-flume-kafka already running.
      exit
    fi
    nohup flume-ng agent -n a1 -f \$FLUME_HOME/conf/file-flume-kafka.conf -Dflume.root.logger=INFO,LOGFILE >/usr/local/flume/apache-flume-1.9.0-bin/log1.txt 2>&1 &
EOF
  done
};;	
"stop"){
  for ip in ${ips[@]}
  do
    echo " --------停止 $ip 采集flume-------"
    ssh -T $ip <<EOF
    ps -ef | grep file-flume-kafka | grep -v grep | awk '{print \$2}' | xargs -n1 kill -9
EOF
  done
};;
"status"){
  for ip in ${ips[@]}
  do
    echo " --------查看 $ip 采集flume-------"
    ssh -T $ip <<EOF
    echo pid: \`ps -ef | grep file-flume-kafka | grep -v grep | awk '{print \$2}'\`
EOF
  done
};;
esac

