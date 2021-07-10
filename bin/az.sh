#!/bin/bash

case $1 in
"start"){
    echo " --------启动 Azkaban-------"
    for ip in doug-hadoop{101,102,103}
    do
        ssh -T $ip <<EOF
cd /usr/local/azkaban/azkaban-exec-server-3.84.4
nohup bash ./bin/start-exec.sh >/dev/null 2>&1 &
EOF
    done
    sleep 3s
    ssh -T doug-hadoop102 <<EOF
cd /usr/local/azkaban/azkaban-web-server-3.84.4
nohup bash ./bin/start-web.sh >/dev/null 2>&1 &
EOF
};;
"stop"){
    echo " --------关闭 Azkaban-------"
    ssh -T doug-hadoop102 <<EOF
cd /usr/local/azkaban/azkaban-web-server-3.84.4
nohup bash ./bin/shutdown-web.sh >/dev/null 2>&1 &
EOF
    for ip in doug-hadoop{101,102,103}
    do
        ssh -T $ip <<EOF
ps -ef | grep executorport=12321 | grep -v grep | awk '{print \$2}' | xargs -n1 sudo kill -9
EOF
    done
};;
esac
