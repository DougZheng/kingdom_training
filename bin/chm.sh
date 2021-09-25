#!/bin/bash

if [[ ! -e $1 ]]; then
  exit
fi
pdir=$(cd -P $(sudo dirname $1); pwd)
fname=$(sudo basename $1) 
path=$pdir/$fname
sudo find $path | xargs ls -ld | while read line
do
  own=`echo $line | awk '{print $3}'`
  if [[ $own == root ]]; then
    continue
  fi
  mod=`echo $line | awk '{print $1}'`
  file=`echo $line | awk '{print $NF}'`
  umod=${mod:1:3}
  sudo chown $own:hadoop $file
  sudo chmod g=$umod $file 
  if [[ -d $file ]]; then
    sudo chmod g+s $file
  fi
done
