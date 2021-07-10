#!/bin/bash

ips=(doug-hadoop101 doug-hadoop102)
for ip in ${ips[@]}
do
  echo "========== $ip =========="
  ssh -T $ip <<EOF
  if [[ \`ps -ef | grep gmall2020-mock-log | grep -v grep | awk '{print \$2}'\` != "" ]]; then
    echo $ip: gmall2020-mock-log already running.
    if [[ $1 != force ]]; then
      exit
    fi
    ps -ef | grep gmall2020-mock-log | grep -v grep | awk '{print \$2}' | xargs -n1 kill -9
    echo $ip: kill the running process
  fi
  cd /usr/local/applog
  nohup java -jar gmall2020-mock-log-2020-04-01.jar >/dev/null 2>&1 &
EOF
done 

