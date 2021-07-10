#!/bin/bash
ips=(doug-hadoop101 doug-hadoop102 doug-hadoop103)
cmd=$1
[[ $cmd == status ]] && out=/dev/stdout || out=/dev/null
echo command is $cmd
for ip in ${ips[@]}
do
echo remote to $ip.
ssh $ip >$out 2>&1 <<EOF
    cd
    zkServer.sh $cmd
    exit
EOF
done
echo command done.

