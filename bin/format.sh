#!/bin/bash
ips=(doug-hadoop101 doug-hadoop102 doug-hadoop103)

for ip in ${ips[@]}
do
ssh -T $ip <<EOF
rm -rf $HADOOP_HOME/logs /tmp/hadoop* /data0/dfs /data0/hadoop
mkdir -p /data0/hadoop/hdfs/name
EOF
done

for ip in ${ips[@]}
do
ssh -T $ip <<EOF
hdfs --daemon start journalnode
EOF
done

ssh -T ${ips[0]} <<EOF
hdfs namenode -format <<YON
Y
YON
hdfs --daemon start namenode
EOF

ssh -T ${ips[1]} <<EOF
hdfs namenode -bootstrapStandby
hdfs --daemon start namenode
EOF

ssh -T ${ips[2]} <<EOF
hdfs namenode -bootstrapStandby
hdfs --daemon start namenode
EOF

ssh -T ${ips[0]} <<EOF
stop-all.sh
hdfs zkfc -formatZK <<YON
Y
Y
YON
start-all.sh
EOF

