#!/bin/bash
ips=(doug-hadoop101 doug-hadoop102 doug-hadoop103)
for ip in ${ips[@]}
do
  for file in $@
    do          
      if [[ -e $file ]] 
      then      
        pdir=$(cd -P $(dirname $file); pwd)
        fname=$(basename $file) 
        ssh $ip "mkdir -p $pdir"
        rsync -av $pdir/$fname $ip:$pdir
        echo $pdir              
      else      
        echo $file does not exists! 
      fi      
    done        
done

