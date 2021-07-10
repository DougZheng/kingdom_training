#!/bin/bash

dt_s='2021-06-15'
dt_t='2021-07-02' # 左闭右开
dt_arr=$(
while [[ $dt_s < $dt_t ]]
do
  echo $dt_s
  dt_s=`date -d "+1 day $dt_s" +%F`
done)

for do_date in ${dt_arr[@]}
do
  echo ============ "$do_date" ============
  run_day.sh $do_date
done
