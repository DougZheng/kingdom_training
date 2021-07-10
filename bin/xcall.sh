#! /bin/bash
 
ips=(doug-hadoop101 doug-hadoop102 doug-hadoop103)
for ip in ${ips[@]}
do
  echo --------- $ip ----------
  ssh -T $ip <<EOF
  $*
EOF
done

