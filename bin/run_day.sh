#!/bin/bash

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [ -n "$1" ] ;then
    do_date=$1
else
    do_date=`date -d "-1 day" +%F`
fi

gmall_mock_db.sh $do_date

hdfs_to_ods_log.sh $do_date

ods_to_dwd_log.sh $do_date

mysql_to_hdfs.sh all $do_date

hdfs_to_ods_db.sh all $do_date

ods_to_dwd_db.sh all $do_date

dwd_to_dws.sh $do_date

dws_to_dwt.sh $do_date

dwt_to_ads.sh $do_date

hdfs_to_mysql.sh all

