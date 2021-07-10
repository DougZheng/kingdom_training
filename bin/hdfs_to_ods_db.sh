# !bin/base
#接受外部传入的日期
# -n 是一个逻辑运算符，用于判断后面的字符串长度是否为0，为0返回false，否则返回true
if [[ $2 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
	do_date=$2
else
#默认使用当前日期的前一天
	do_date=$(date -d 'yesterday' '+%F')
fi

#echo $do_date

#声明hql
sql1=" 
use gmall;

load data inpath '/origin_data/gmall/db/order_info/$do_date' OVERWRITE into table ods_order_info partition(dt='$do_date');

load data inpath '/origin_data/gmall/db/order_detail/$do_date' OVERWRITE into table ods_order_detail partition(dt='$do_date');

load data inpath '/origin_data/gmall/db/sku_info/$do_date' OVERWRITE into table ods_sku_info partition(dt='$do_date');

load data inpath '/origin_data/gmall/db/user_info/$do_date' OVERWRITE into table ods_user_info partition(dt='$do_date');

load data inpath '/origin_data/gmall/db/payment_info/$do_date' OVERWRITE into table ods_payment_info partition(dt='$do_date');

load data inpath '/origin_data/gmall/db/base_category1/$do_date' OVERWRITE into table ods_base_category1 partition(dt='$do_date');

load data inpath '/origin_data/gmall/db/base_category2/$do_date' OVERWRITE into table ods_base_category2 partition(dt='$do_date');

load data inpath '/origin_data/gmall/db/base_category3/$do_date' OVERWRITE into table ods_base_category3 partition(dt='$do_date'); 

load data inpath '/origin_data/gmall/db/base_trademark/$do_date' OVERWRITE into table ods_base_trademark partition(dt='$do_date'); 

load data inpath '/origin_data/gmall/db/activity_info/$do_date' OVERWRITE into table ods_activity_info partition(dt='$do_date'); 

load data inpath '/origin_data/gmall/db/activity_order/$do_date' OVERWRITE into table ods_activity_order partition(dt='$do_date'); 

load data inpath '/origin_data/gmall/db/cart_info/$do_date' OVERWRITE into table ods_cart_info partition(dt='$do_date'); 

load data inpath '/origin_data/gmall/db/comment_info/$do_date' OVERWRITE into table ods_comment_info partition(dt='$do_date'); 

load data inpath '/origin_data/gmall/db/coupon_info/$do_date' OVERWRITE into table ods_coupon_info partition(dt='$do_date'); 

load data inpath '/origin_data/gmall/db/coupon_use/$do_date' OVERWRITE into table ods_coupon_use partition(dt='$do_date'); 

load data inpath '/origin_data/gmall/db/favor_info/$do_date' OVERWRITE into table ods_favor_info partition(dt='$do_date'); 

load data inpath '/origin_data/gmall/db/order_refund_info/$do_date' OVERWRITE into table ods_order_refund_info partition(dt='$do_date'); 

load data inpath '/origin_data/gmall/db/order_status_log/$do_date' OVERWRITE into table ods_order_status_log partition(dt='$do_date'); 

load data inpath '/origin_data/gmall/db/spu_info/$do_date' OVERWRITE into table ods_spu_info partition(dt='$do_date'); 

load data inpath '/origin_data/gmall/db/activity_rule/$do_date' OVERWRITE into table ods_activity_rule partition(dt='$do_date'); 

load data inpath '/origin_data/gmall/db/base_dic/$do_date' OVERWRITE into table ods_base_dic partition(dt='$do_date'); 
"

sql2=" 
use gmall;

load data inpath '/origin_data/gmall/db/base_province/$do_date' OVERWRITE into table ods_base_province;

load data inpath '/origin_data/gmall/db/base_region/$do_date' OVERWRITE into table ods_base_region;
"
case $1 in
"first"){
    hive -e "$sql1$sql2"
};;
"all"){
    hive -e "$sql1"
};;
"other"){
    hive -e "$sql2"
};;
esac


