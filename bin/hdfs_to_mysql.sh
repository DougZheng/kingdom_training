#!/bin/bash

hive_db_name=gmall
mysql_db_name=gmall_report

export_data() {
$SQOOP_HOME/bin/sqoop export \
-Dmapreduce.job.queuename=hive \
--connect "jdbc:mysql://doug-hadoop102:3306/${mysql_db_name}?useUnicode=true&characterEncoding=utf-8"  \
--username dougzheng \
--password @zbsmysql \
--table $1 \
--num-mappers 1 \
--export-dir /warehouse/$hive_db_name/ads/$1 \
--input-fields-terminated-by "\t" \
--update-mode allowinsert \
--update-key $2 \
--input-null-string '\\N'    \
--input-null-non-string '\\N'
}

case $1 in
"ads_uv_count")
  export_data "ads_uv_count" "dt"
;;
"ads_new_mid_count")
  export_data "ads_new_mid_count" "create_date"
;;
"ads_continuity_uv_count")
  export_data "ads_continuity_uv_count" "dt"
;;
"ads_wastage_count")
  export_data "ads_wastage_count" "dt"
;;
"ads_back_count")
  export_data "ads_back_count" "dt"
;;
"ads_user_topic")
  export_data "ads_user_topic" "dt"
;;
"ads_user_action_convert_day")
  export_data "ads_user_action_convert_day" "dt"
;;
"ads_product_sale_topN")
  export_data "ads_product_sale_topN" "dt,sku_id"
;;
"ads_product_cart_topN")
  export_data "ads_product_cart_topN" "dt,sku_id"
;;
"ads_trademark_sale")
  export_data "ads_trademark_sale" "dt,tm_name"
;;
"ads_spu_sale")
  export_data "ads_spu_sale" "dt,tm_name,spu_name"
;;
"ads_trademark_appraise")
  export_data "ads_trademark_appraise" "dt,tm_name"
;;
"ads_order_daycount")
  export_data "ads_order_daycount" "dt"
;;
"ads_payment_daycount")
  export_data "ads_payment_daycount" "dt"
;;
"ads_area_topic")
  export_data "ads_area_topic" "id,dt"
;;
"all")
  export_data "ads_uv_count" "dt"
  export_data "ads_new_mid_count" "create_date"
  export_data "ads_continuity_uv_count" "dt"
  export_data "ads_wastage_count" "dt"
  export_data "ads_back_count" "dt"
  export_data "ads_user_topic" "dt"
  export_data "ads_user_action_convert_day" "dt"
  export_data "ads_product_sale_topN" "dt,sku_id"
  export_data "ads_product_cart_topN" "dt,sku_id"
  export_data "ads_trademark_sale" "dt,tm_name"
  export_data "ads_spu_sale" "dt,tm_name,spu_name"
  export_data "ads_trademark_appraise" "dt,tm_name"
  export_data "ads_order_daycount" "dt"
  export_data "ads_payment_daycount" "dt"
  export_data "ads_area_topic" "id,dt"
;;
esac
