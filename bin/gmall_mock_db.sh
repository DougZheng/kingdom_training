#!/bin/bash

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [[ $1 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
   do_date=$1
else 
   do_date=`date -d "-1 day" +%F`
fi 

for ip in doug-hadoop102
do
  ssh -T $ip <<EOF
  cd /usr/local/db_log
  sed -i "s/^mock\.date=.*/mock.date=$do_date/" application.properties
EOF
done


for ip in doug-hadoop102
do
  echo "========== $ip =========="
  ssh -T $ip <<EOF
  cd /usr/local/db_log
  nohup java -jar gmall2020-mock-db-2020-04-01.jar >/dev/null 2>&1 &
EOF
done 

sleep 30s
