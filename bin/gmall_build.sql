use gmall;

drop table if exists ods_log;
CREATE EXTERNAL TABLE ods_log ( line  string)
PARTITIONED BY ( dt  string) -- 按照时间创建分区
STORED AS -- 指定存储方式，读数据采用LzoTextInputFormat；
  INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
  OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION '/warehouse/gmall/ods/ods_log'  -- 指定数据在hdfs上的存储位置
;

drop table if exists ods_order_info;
create external table ods_order_info (
     id  string COMMENT '编号',
     consignee  string COMMENT '收货人',
     consignee_tel  string COMMENT '收件人电话',
     final_total_amount  decimal(16,2) COMMENT '总金额',
     order_status  string COMMENT '订单状态',
     user_id  string COMMENT '用户id',
     delivery_address  string COMMENT '送货地址',
     order_comment  string COMMENT '订单备注',
     out_trade_no  string COMMENT '订单交易编号（第三方支付用）',
     trade_body  string COMMENT '订单描述（第三方支付用）',
     create_time  string COMMENT '创建时间',
     operate_time  string COMMENT '操作时间',
     expire_time  string COMMENT '失效时间',
     tracking_no  string COMMENT '物流单编号',
     parent_order_id  string COMMENT '父订单编号',
     img_url  string COMMENT '图片路径',
     province_id  string COMMENT '地区',
     benefit_reduce_amount  decimal(16,2) COMMENT '优惠金额',
     original_total_amount  decimal(16,2) COMMENT '原价金额',
     feight_fee  decimal(16,2) COMMENT '运费'
) COMMENT '订单表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_order_info/';

drop table if exists ods_order_detail;
create external table ods_order_detail (
     id  string COMMENT '编号',
     order_id  string COMMENT '订单编号',
     user_id  string COMMENT '用户id',
     sku_id  string COMMENT 'sku_id',
     sku_name  string COMMENT 'sku名称（冗余）',
     img_url  string COMMENT '图片名称（冗余）',
     order_price  decimal(16,2) COMMENT '购买价格（下单时sku价格）',
     sku_num  bigint COMMENT '购买个数',
     create_time  string COMMENT '创建时间',
     source_type  string COMMENT '来源类型',
     source_id  string COMMENT '来源编号'
) COMMENT '订单详情表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_order_detail/';

drop table if exists ods_sku_info;
create external table ods_sku_info (
     id  string COMMENT 'skuid(itemID)',
     spu_id  string COMMENT 'spuid',
     price  decimal(16,2) COMMENT '价格',
     sku_name  string COMMENT 'sku名称',
     sku_desc  string COMMENT '商品规格描述',
     weight  decimal(16,2) COMMENT '重量',
     tm_id  string COMMENT '品牌（冗余）',
     category3_id  string COMMENT '三级分类id（冗余）',
     sku_default_img  string COMMENT '默认显示图片（冗余）',
     create_time  string COMMENT '创建时间'
) COMMENT 'SKU商品表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_sku_info/';

drop table if exists ods_user_info;
create external table ods_user_info (
     id  string COMMENT '编号',
     login_name  string COMMENT '用户名称',
     nick_name  string COMMENT '用户昵称',
     passwd  string COMMENT '用户密码',
     name  string COMMENT '用户姓名',
     phone_num  string COMMENT '手机号',
     email  string COMMENT '邮箱',
     head_img  string COMMENT '头像',
     user_level  string COMMENT '用户级别',
     birthday  string COMMENT '用户生日',
     gender  string COMMENT '性别 M男，F女',
     create_time  string COMMENT '创建时间',
     operate_time  string COMMENT '修改时间'
) COMMENT '用户表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_user_info/';

drop table if exists ods_base_category1;
create external table ods_base_category1 (
     id  string COMMENT '编号',
     name  string COMMENT '分类名称'
) COMMENT '商品一级分类表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_base_category1/';

drop table if exists ods_base_category2;
create external table ods_base_category2 (
     id  string COMMENT '编号',
     name  string COMMENT '二级分类名称',
     category1_id  string COMMENT '一级分类编号'
) COMMENT '商品二级分类表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_base_category2/';

drop table if exists ods_base_category3;
create external table ods_base_category3 (
     id  string COMMENT '编号',
     name  string COMMENT '三级分类名称',
     category2_id  string COMMENT '二级分类编号'
) COMMENT '商品三级分类表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_base_category3/';

drop table if exists ods_payment_info;
create external table ods_payment_info (
     id  string COMMENT '编号',
     out_trade_no  string COMMENT '对外业务编号',
     order_id  string COMMENT '订单编号',
     user_id  string COMMENT '用户编号',
     alipay_trade_no  string COMMENT '支付宝交易流水编号',
     total_amount  decimal(16,2) COMMENT '支付金额',
     subject  string COMMENT '交易内容',
     payment_type  string COMMENT '支付方式',
     payment_time  string COMMENT '支付时间'
) COMMENT '支付流水表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_payment_info/';

drop table if exists ods_base_province;
create external table ods_base_province (
     id  bigint COMMENT 'id',
     name  string COMMENT '省份名称',
     region_id  string COMMENT '地区id',
     area_code  string COMMENT '地区编码',
     iso_code  string COMMENT '国际编码'
) COMMENT '省份表'
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_base_province/';

drop table if exists ods_base_region;
create external table ods_base_region (
     id  string COMMENT '地区id',
     region_name  string COMMENT '地区名称'
) COMMENT '地区表'
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_base_region/';

drop table if exists ods_base_trademark;
create external table ods_base_trademark (
     tm_id  string COMMENT '品牌id',
     tm_name  string COMMENT '品牌名称'
) COMMENT '品牌表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_base_trademark/';

drop table if exists ods_order_status_log;
create external table ods_order_status_log (
     id  string COMMENT '编号',
     order_id  string COMMENT '订单编号',
     order_status  string COMMENT '订单状态',
     operate_time  string COMMENT '操作时间'
) COMMENT '订单状态表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_order_status_log/';

drop table if exists ods_spu_info;
create external table ods_spu_info (
     id  string COMMENT '商品id',
     spu_name  string COMMENT '商品名称',
     description  string COMMENT '商品描述（后台简述）',
     category3_id  string COMMENT '三级分类id',
     tm_id  string COMMENT '品牌id'
) COMMENT 'SPU商品表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_spu_info/';

drop table if exists ods_comment_info;
create external table ods_comment_info (
     id  string COMMENT '编号',
     user_id  string COMMENT '用户名称',
     sku_id  string COMMENT 'skuid',
     spu_id  string COMMENT '商品id',
     order_id  string COMMENT '订单编号',
     appraise  string COMMENT '评价 1 好评 2 中评 3 差评',
     comment_txt  string COMMENT '评价内容',
     create_time  string COMMENT '创建时间',
     operate_time  string COMMENT '修改时间'
) COMMENT '商品评论表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_comment_info/';

drop table if exists ods_order_refund_info;
create external table ods_order_refund_info (
     id  string COMMENT '编号',
     user_id  string COMMENT '用户id',
     order_id  string COMMENT '订单编号',
     sku_id  string COMMENT 'skuid',
     refund_type  string COMMENT '退款类型',
     refund_num  bigint COMMENT '退货件数',
     refund_amount  decimal(16,2) COMMENT '退款金额',
     refund_reason_type  string COMMENT '原因类型',
     refund_reason_txt  string COMMENT '原因内容',
     create_time  string COMMENT '创建时间'
) COMMENT '退单表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_order_refund_info/';

drop table if exists ods_cart_info;
create external table ods_cart_info (
     id  string COMMENT '编号',
     user_id  string COMMENT '用户id',
     sku_id  string COMMENT 'skuid',
     cart_price  decimal(16,2) COMMENT '放入购物车时价格',
     sku_num  bigint COMMENT '数量',
     img_url  string COMMENT '图片文件',
     sku_name  string COMMENT 'sku名称（冗余）',
     create_time  string COMMENT '创建时间',
     operate_time  string COMMENT '修改时间',
     is_ordered  string COMMENT '是否已经下单',
     order_time  string COMMENT '下单时间', 
     source_type  string COMMENT '来源类型',
     source_id  string COMMENT '来源编号'
) COMMENT '加购表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_cart_info/';

drop table if exists ods_favor_info;
create external table ods_favor_info (
     id  string COMMENT '编号',
     user_id  string COMMENT '用户id',
     sku_id  string COMMENT 'skuid',
     spu_id  string COMMENT '商品id',
     is_cancel  string COMMENT '是否已取消 0 正常 1 已取消',
     create_time  string COMMENT '创建时间',
     cancel_time  string COMMENT '修改时间'
) COMMENT '商品收藏表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_favor_info/';

drop table if exists ods_coupon_use;
create external table ods_coupon_use (
     id  string COMMENT '编号',
     coupon_id  string COMMENT '优惠券ID',
     user_id  string COMMENT '用户ID',
     order_id  string COMMENT '订单ID',
     coupon_status  string COMMENT '购物券状态',
     get_time  string COMMENT '领券时间',
     using_time  string COMMENT '使用时间',
     used_time  string COMMENT '支付时间',
     expire_time  string COMMENT '过期时间'
) COMMENT '优惠券领用表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_coupon_use/';

drop table if exists ods_coupon_info;
create external table ods_coupon_info (
     id  string COMMENT '优惠券编号',
     coupon_name  string COMMENT '优惠券名称',
     coupon_type  string COMMENT '优惠券类型 1 现金券 2 折扣券 3 满减券 4 满件打折券',
     condition_amount  decimal(16,2) COMMENT '满减金额',
     condition_num  bigint COMMENT '满减件数',
     activity_id  string COMMENT '活动编号',
     benefit_amount  decimal(16,2) COMMENT '优惠金额',
     benefit_discount  decimal(16,2) COMMENT '优惠折扣',
     create_time  string COMMENT '创建时间',
     range_type  string COMMENT '范围类型 1、商品 2、品类 3、品牌',
     spu_id  string COMMENT '商品id',
     tm_id  string COMMENT '品牌id',
     category3_id  string COMMENT '品类id',
     limit_num  bigint COMMENT '最多领用次数',
     operate_time  string COMMENT '修改时间',
     expire_time  string COMMENT '过期时间'
) COMMENT '优惠券表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_coupon_info/';

drop table if exists ods_activity_info;
create external table ods_activity_info (
     id  string COMMENT '活动id',
     activity_name  string COMMENT '活动名称',
     activity_type  string COMMENT '活动类型',
     activity_desc  string COMMENT '活动描述',
     start_time  string COMMENT '开始时间',
     end_time  string COMMENT '结束时间',
     create_time  string COMMENT '创建时间'
) COMMENT '活动表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_activity_info/';

drop table if exists ods_activity_order;
create external table ods_activity_order (
     id  string COMMENT '编号',
     activity_id  string COMMENT '活动id',
     order_id  string COMMENT '订单编号',
     create_time  string COMMENT '发生时间'
) COMMENT '活动订单关联表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_activity_order/';

drop table if exists ods_activity_rule;
create external table ods_activity_rule (
     id  string COMMENT '编号',
     activity_id  string COMMENT '活动id',
     condition_amount  decimal(16,2) COMMENT '满减金额',
     condition_num  string COMMENT '满减件数',
     benefit_amount  decimal(16,2) COMMENT '优惠金额',
     benefit_discount  decimal(16,2) COMMENT '优惠折扣',
     benefit_level  string COMMENT '优惠级别'
) COMMENT '优惠规则表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_activity_rule/';

drop table if exists ods_base_dic;
create external table ods_base_dic (
     dic_code  string COMMENT '编号',
     dic_name  string COMMENT '编码名称',
     parent_code  string COMMENT '父编码',
     create_time  string COMMENT '创建日期',
     operate_time  string COMMENT '修改日期'
) COMMENT '编码字典表'
PARTITIONED BY ( dt  string)
row format delimited fields terminated by '\t'
STORED AS
INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/warehouse/gmall/ods/ods_base_dic/';



drop table if exists dwd_start_log;
CREATE EXTERNAL TABLE dwd_start_log(
     area_code  string COMMENT '地区编码',
     brand  string COMMENT '手机品牌', 
     channel  string COMMENT '渠道', 
     model  string COMMENT '手机型号', 
     mid_id  string COMMENT '设备id', 
     os  string COMMENT '操作系统', 
     user_id  string COMMENT '会员id', 
     version_code  string COMMENT 'app版本号', 
     entry  string COMMENT ' icon手机图标  notice 通知   install 安装后启动',
     loading_time  bigint COMMENT '启动加载时间',
     open_ad_id  string COMMENT '广告页ID ',
     open_ad_ms  bigint COMMENT '广告总共播放时间', 
     open_ad_skip_ms  bigint COMMENT '用户跳过广告时点', 
     ts  bigint COMMENT '时间'
) COMMENT '启动日志表'
PARTITIONED BY (dt string) -- 按照时间创建分区
stored as parquet -- 采用parquet列式存储
LOCATION '/warehouse/gmall/dwd/dwd_start_log' -- 指定在HDFS上存储位置
TBLPROPERTIES('parquet.compression'='lzo') -- 采用LZO压缩
;

drop table if exists dwd_page_log;
CREATE EXTERNAL TABLE dwd_page_log(
     area_code  string COMMENT '地区编码',
     brand  string COMMENT '手机品牌', 
     channel  string COMMENT '渠道', 
     model  string COMMENT '手机型号', 
     mid_id  string COMMENT '设备id', 
     os  string COMMENT '操作系统', 
     user_id  string COMMENT '会员id', 
     version_code  string COMMENT 'app版本号', 
     during_time  bigint COMMENT '持续时间毫秒',
     page_item  string COMMENT '目标id ', 
     page_item_type  string COMMENT '目标类型', 
     last_page_id  string COMMENT '上页类型', 
     page_id  string COMMENT '页面ID ',
     source_type  string COMMENT '来源类型', 
     ts  bigint
) COMMENT '页面日志表'
PARTITIONED BY (dt string)
stored as parquet
LOCATION '/warehouse/gmall/dwd/dwd_page_log'
TBLPROPERTIES('parquet.compression'='lzo');

drop table if exists dwd_action_log;
CREATE EXTERNAL TABLE dwd_action_log(
     area_code  string COMMENT '地区编码',
     brand  string COMMENT '手机品牌', 
     channel  string COMMENT '渠道', 
     model  string COMMENT '手机型号', 
     mid_id  string COMMENT '设备id', 
     os  string COMMENT '操作系统', 
     user_id  string COMMENT '会员id', 
     version_code  string COMMENT 'app版本号', 
     during_time  bigint COMMENT '持续时间毫秒', 
     page_item  string COMMENT '目标id ', 
     page_item_type  string COMMENT '目标类型', 
     last_page_id  string COMMENT '上页类型', 
     page_id  string COMMENT '页面id ',
     source_type  string COMMENT '来源类型', 
     action_id  string COMMENT '动作id',
     item  string COMMENT '目标id ',
     item_type  string COMMENT '目标类型', 
     ts  bigint COMMENT '时间'
) COMMENT '动作日志表'
PARTITIONED BY (dt string)
stored as parquet
LOCATION '/warehouse/gmall/dwd/dwd_action_log'
TBLPROPERTIES('parquet.compression'='lzo');

drop table if exists dwd_display_log;
CREATE EXTERNAL TABLE dwd_display_log(
area_code string COMMENT '地区编码',
brand string COMMENT '手机品牌', 
channel string COMMENT '渠道', 
model string COMMENT '手机型号', 
mid_id string COMMENT '设备id', 
os string COMMENT '操作系统', 
user_id string COMMENT '会员id', 
version_code string COMMENT 'app版本号', 
during_time bigint COMMENT 'app版本号',
page_item string COMMENT '目标id ', 
page_item_type string COMMENT '目标类型', 
last_page_id string COMMENT '上页类型', 
page_id string COMMENT '页面ID ',
source_type string COMMENT '来源类型', 
ts bigint COMMENT 'app版本号',
display_type string COMMENT '曝光类型',
item string COMMENT '曝光对象id ',
item_type string COMMENT 'app版本号', 
`order` bigint COMMENT '出现顺序'
) COMMENT '曝光日志表'
PARTITIONED BY (dt string)
stored as parquet
LOCATION '/warehouse/gmall/dwd/dwd_display_log'
TBLPROPERTIES('parquet.compression'='lzo');

drop table if exists dwd_error_log;
CREATE EXTERNAL TABLE dwd_error_log(
     area_code  string COMMENT '地区编码',
     brand  string COMMENT '手机品牌', 
     channel  string COMMENT '渠道', 
     model  string COMMENT '手机型号', 
     mid_id  string COMMENT '设备id', 
     os  string COMMENT '操作系统', 
     user_id  string COMMENT '会员id', 
     version_code  string COMMENT 'app版本号', 
     page_item  string COMMENT '目标id ', 
     page_item_type  string COMMENT '目标类型', 
     last_page_id  string COMMENT '上页类型', 
     page_id  string COMMENT '页面ID ',
     source_type  string COMMENT '来源类型', 
     entry  string COMMENT ' icon手机图标  notice 通知 install 安装后启动',
     loading_time  string COMMENT '启动加载时间',
     open_ad_id  string COMMENT '广告页ID ',
     open_ad_ms  string COMMENT '广告总共播放时间', 
     open_ad_skip_ms  string COMMENT '用户跳过广告时点',
     actions  string COMMENT '动作',
     displays  string COMMENT '曝光',
     ts  string COMMENT '时间',
     error_code  string COMMENT '错误码',
     msg  string COMMENT '错误信息'
) COMMENT '错误日志表'
PARTITIONED BY (dt string)
stored as parquet
LOCATION '/warehouse/gmall/dwd/dwd_error_log'
TBLPROPERTIES('parquet.compression'='lzo');

DROP TABLE IF EXISTS  dwd_dim_sku_info ;
CREATE EXTERNAL TABLE  dwd_dim_sku_info  (
     id  string COMMENT '商品id',
     spu_id  string COMMENT 'spuid',
     price  decimal(16,2) COMMENT '商品价格',
     sku_name  string COMMENT '商品名称',
     sku_desc  string COMMENT '商品描述',
     weight  decimal(16,2) COMMENT '重量',
     tm_id  string COMMENT '品牌id',
     tm_name  string COMMENT '品牌名称',
     category3_id  string COMMENT '三级分类id',
     category2_id  string COMMENT '二级分类id',
     category1_id  string COMMENT '一级分类id',
     category3_name  string COMMENT '三级分类名称',
     category2_name  string COMMENT '二级分类名称',
     category1_name  string COMMENT '一级分类名称',
     spu_name  string COMMENT 'spu名称',
     create_time  string COMMENT '创建时间'
) COMMENT '商品维度表'
PARTITIONED BY ( dt  string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_dim_sku_info/'
tblproperties ("parquet.compression"="lzo");

drop table if exists dwd_dim_coupon_info;
create external table dwd_dim_coupon_info(
     id  string COMMENT '购物券编号',
     coupon_name  string COMMENT '购物券名称',
     coupon_type  string COMMENT '购物券类型 1 现金券 2 折扣券 3 满减券 4 满件打折券',
     condition_amount  decimal(16,2) COMMENT '满额数',
     condition_num  bigint COMMENT '满件数',
     activity_id  string COMMENT '活动编号',
     benefit_amount  decimal(16,2) COMMENT '减金额',
     benefit_discount  decimal(16,2) COMMENT '折扣',
     create_time  string COMMENT '创建时间',
     range_type  string COMMENT '范围类型 1、商品 2、品类 3、品牌',
     spu_id  string COMMENT '商品id',
     tm_id  string COMMENT '品牌id',
     category3_id  string COMMENT '品类id',
     limit_num  bigint COMMENT '最多领用次数',
     operate_time   string COMMENT '修改时间',
     expire_time   string COMMENT '过期时间'
) COMMENT '优惠券维度表'
PARTITIONED BY ( dt  string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_dim_coupon_info/'
tblproperties ("parquet.compression"="lzo");

drop table if exists dwd_dim_activity_info;
create external table dwd_dim_activity_info(
     id  string COMMENT '编号',
     activity_name  string  COMMENT '活动名称',
     activity_type  string  COMMENT '活动类型',
     start_time  string  COMMENT '开始时间',
     end_time  string  COMMENT '结束时间',
     create_time  string  COMMENT '创建时间'
) COMMENT '活动信息表'
PARTITIONED BY ( dt  string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_dim_activity_info/'
tblproperties ("parquet.compression"="lzo");

DROP TABLE IF EXISTS  dwd_dim_base_province ;
CREATE EXTERNAL TABLE  dwd_dim_base_province  (
     id  string COMMENT 'id',
     province_name  string COMMENT '省市名称',
     area_code  string COMMENT '地区编码',
     iso_code  string COMMENT 'ISO编码',
     region_id  string COMMENT '地区id',
     region_name  string COMMENT '地区名称'
) COMMENT '地区维度表'
stored as parquet
location '/warehouse/gmall/dwd/dwd_dim_base_province/'
tblproperties ("parquet.compression"="lzo");

DROP TABLE IF EXISTS  dwd_dim_date_info ;
CREATE EXTERNAL TABLE  dwd_dim_date_info (
     date_id  string COMMENT '日',
     week_id  string COMMENT '周',
     week_day  string COMMENT '周的第几天',
     day  string COMMENT '每月的第几天',
     month  string COMMENT '第几月',
     quarter  string COMMENT '第几季度',
     year  string COMMENT '年',
     is_workday  string COMMENT '是否是周末',
     holiday_id  string COMMENT '是否是节假日'
) COMMENT '时间维度表'
stored as parquet
location '/warehouse/gmall/dwd/dwd_dim_date_info/'
tblproperties ("parquet.compression"="lzo");

drop table if exists dwd_fact_order_detail;
create external table dwd_fact_order_detail (
     id  string COMMENT '订单编号',
     order_id  string COMMENT '订单号',
     user_id  string COMMENT '用户id',
     sku_id  string COMMENT 'sku商品id',
     sku_name  string COMMENT '商品名称',
     order_price  decimal(16,2) COMMENT '商品价格',
     sku_num  bigint COMMENT '商品数量',
     create_time  string COMMENT '创建时间',
     province_id  string COMMENT '省份ID',
     source_type  string COMMENT '来源类型',
     source_id  string COMMENT '来源编号',
     original_amount_d  decimal(20,2) COMMENT '原始价格分摊',
     final_amount_d  decimal(20,2) COMMENT '购买价格分摊',
     feight_fee_d  decimal(20,2) COMMENT '分摊运费',
     benefit_reduce_amount_d  decimal(20,2) COMMENT '分摊优惠'
) COMMENT '订单明细事实表表'
PARTITIONED BY ( dt  string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_fact_order_detail/'
tblproperties ("parquet.compression"="lzo");

drop table if exists dwd_fact_payment_info;
create external table dwd_fact_payment_info (
     id  string COMMENT 'id',
     out_trade_no  string COMMENT '对外业务编号',
     order_id  string COMMENT '订单编号',
     user_id  string COMMENT '用户编号',
     alipay_trade_no  string COMMENT '支付宝交易流水编号',
     payment_amount     decimal(16,2) COMMENT '支付金额',
     subject          string COMMENT '交易内容',
     payment_type  string COMMENT '支付类型',
     payment_time  string COMMENT '支付时间',
     province_id  string COMMENT '省份ID'
) COMMENT '支付事实表表'
PARTITIONED BY ( dt  string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_fact_payment_info/'
tblproperties ("parquet.compression"="lzo");

drop table if exists dwd_fact_order_refund_info;
create external table dwd_fact_order_refund_info(
     id  string COMMENT '编号',
     user_id  string COMMENT '用户ID',
     order_id  string COMMENT '订单ID',
     sku_id  string COMMENT '商品ID',
     refund_type  string COMMENT '退款类型',
     refund_num  bigint COMMENT '退款件数',
     refund_amount  decimal(16,2) COMMENT '退款金额',
     refund_reason_type  string COMMENT '退款原因类型',
     create_time  string COMMENT '退款时间'
) COMMENT '退款事实表'
PARTITIONED BY ( dt  string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_fact_order_refund_info/'
tblproperties ("parquet.compression"="lzo");

drop table if exists dwd_fact_comment_info;
create external table dwd_fact_comment_info(
     id  string COMMENT '编号',
     user_id  string COMMENT '用户ID',
     sku_id  string COMMENT '商品sku',
     spu_id  string COMMENT '商品spu',
     order_id  string COMMENT '订单ID',
     appraise  string COMMENT '评价',
     create_time  string COMMENT '评价时间'
) COMMENT '评价事实表'
PARTITIONED BY ( dt  string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_fact_comment_info/'
tblproperties ("parquet.compression"="lzo");

drop table if exists dwd_fact_cart_info;
create external table dwd_fact_cart_info(
     id  string COMMENT '编号',
     user_id  string  COMMENT '用户id',
     sku_id  string  COMMENT 'skuid',
     cart_price  string  COMMENT '放入购物车时价格',
     sku_num  string  COMMENT '数量',
     sku_name  string  COMMENT 'sku名称 (冗余)',
     create_time  string  COMMENT '创建时间',
     operate_time  string COMMENT '修改时间',
     is_ordered  string COMMENT '是否已经下单。1为已下单;0为未下单',
     order_time  string  COMMENT '下单时间',
     source_type  string COMMENT '来源类型',
     srouce_id  string COMMENT '来源编号'
) COMMENT '加购事实表'
PARTITIONED BY ( dt  string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_fact_cart_info/'
tblproperties ("parquet.compression"="lzo");

drop table if exists dwd_fact_favor_info;
create external table dwd_fact_favor_info(
     id  string COMMENT '编号',
     user_id  string  COMMENT '用户id',
     sku_id  string  COMMENT 'skuid',
     spu_id  string  COMMENT 'spuid',
     is_cancel  string  COMMENT '是否取消',
     create_time  string  COMMENT '收藏时间',
     cancel_time  string  COMMENT '取消时间'
) COMMENT '收藏事实表'
PARTITIONED BY ( dt  string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_fact_favor_info/'
tblproperties ("parquet.compression"="lzo");

drop table if exists dwd_fact_coupon_use;
create external table dwd_fact_coupon_use(
     id  string COMMENT '编号',
     coupon_id  string  COMMENT '优惠券ID',
     user_id  string  COMMENT 'userid',
     order_id  string  COMMENT '订单id',
     coupon_status  string  COMMENT '优惠券状态',
     get_time  string  COMMENT '领取时间',
     using_time  string  COMMENT '使用时间(下单)',
     used_time  string  COMMENT '使用时间(支付)'
) COMMENT '优惠券领用事实表'
PARTITIONED BY ( dt  string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_fact_coupon_use/'
tblproperties ("parquet.compression"="lzo");

drop table if exists dwd_fact_order_info;
create external table dwd_fact_order_info (
     id  string COMMENT '订单编号',
     order_status  string COMMENT '订单状态',
     user_id  string COMMENT '用户id',
     out_trade_no  string COMMENT '支付流水号',
     create_time  string COMMENT '创建时间(未支付状态)',
     payment_time  string COMMENT '支付时间(已支付状态)',
     cancel_time  string COMMENT '取消时间(已取消状态)',
     finish_time  string COMMENT '完成时间(已完成状态)',
     refund_time  string COMMENT '退款时间(退款中状态)',
     refund_finish_time  string COMMENT '退款完成时间(退款完成状态)',
     province_id  string COMMENT '省份ID',
     activity_id  string COMMENT '活动ID',
     original_total_amount  decimal(16,2) COMMENT '原价金额',
     benefit_reduce_amount  decimal(16,2) COMMENT '优惠金额',
     feight_fee  decimal(16,2) COMMENT '运费',
     final_total_amount  decimal(16,2) COMMENT '订单金额'
) COMMENT '订单事实表'
PARTITIONED BY ( dt  string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_fact_order_info/'
tblproperties ("parquet.compression"="lzo");

drop table if exists dwd_dim_user_info_his;
create external table dwd_dim_user_info_his(
     id  string COMMENT '用户id',
     name  string COMMENT '姓名', 
     birthday  string COMMENT '生日',
     gender  string COMMENT '性别',
     email  string COMMENT '邮箱',
     user_level  string COMMENT '用户等级',
     create_time  string COMMENT '创建时间',
     operate_time  string COMMENT '操作时间',
     start_date   string COMMENT '有效开始日期',
     end_date   string COMMENT '有效结束日期'
) COMMENT '用户拉链表'
stored as parquet
location '/warehouse/gmall/dwd/dwd_dim_user_info_his/'
tblproperties ("parquet.compression"="lzo");

drop table if exists dwd_dim_user_info_his_tmp;
create external table dwd_dim_user_info_his_tmp(
     id  string COMMENT '用户id',
     name  string COMMENT '姓名', 
     birthday  string COMMENT '生日',
     gender  string COMMENT '性别',
     email  string COMMENT '邮箱',
     user_level  string COMMENT '用户等级',
     create_time  string COMMENT '创建时间',
     operate_time  string COMMENT '操作时间',
     start_date   string COMMENT '有效开始日期',
     end_date   string COMMENT '有效结束日期'
) COMMENT '订单拉链临时表'
stored as parquet
location '/warehouse/gmall/dwd/dwd_dim_user_info_his_tmp/'
tblproperties ("parquet.compression"="lzo");

drop table if exists dws_uv_detail_daycount;
create external table dws_uv_detail_daycount
(
     mid_id       string COMMENT '设备id',
     brand        string COMMENT '手机品牌',
     model        string COMMENT '手机型号',
     login_count  bigint COMMENT '活跃次数',
     page_stats   array<struct<page_id:string,page_count:bigint>> COMMENT '页面访问统计'
) COMMENT '每日设备行为表'
partitioned by(dt string)
stored as parquet
location '/warehouse/gmall/dws/dws_uv_detail_daycount'
tblproperties ("parquet.compression"="lzo");

drop table if exists dws_user_action_daycount;
create external table dws_user_action_daycount
(   
    user_id string comment '用户 id',
    login_count bigint comment '登录次数',
    cart_count bigint comment '加入购物车次数',
    order_count bigint comment '下单次数',
    order_amount    decimal(16,2)  comment '下单金额',
    payment_count   bigint      comment '支付次数',
    payment_amount  decimal(16,2) comment '支付金额',
    order_detail_stats array<struct<sku_id:string,sku_num:bigint,order_count:bigint,order_amount:decimal(20,2)>> comment '下单明细统计'
) COMMENT '每日会员行为'
PARTITIONED BY ( dt  string)
stored as parquet
location '/warehouse/gmall/dws/dws_user_action_daycount/'
tblproperties ("parquet.compression"="lzo");

drop table if exists dws_sku_action_daycount;
create external table dws_sku_action_daycount 
(   
    sku_id string comment 'sku_id',
    order_count bigint comment '被下单次数',
    order_num bigint comment '被下单件数',
    order_amount decimal(16,2) comment '被下单金额',
    payment_count bigint  comment '被支付次数',
    payment_num bigint comment '被支付件数',
    payment_amount decimal(16,2) comment '被支付金额',
    refund_count bigint  comment '被退款次数',
    refund_num bigint comment '被退款件数',
    refund_amount  decimal(16,2) comment '被退款金额',
    cart_count bigint comment '被加入购物车次数',
    favor_count bigint comment '被收藏次数',
    appraise_good_count bigint comment '好评数',
    appraise_mid_count bigint comment '中评数',
    appraise_bad_count bigint comment '差评数',
    appraise_default_count bigint comment '默认评价数',
    sku_name string comment 'sku_name', 
    spu_id string comment 'spu_id', 
    spu_name string comment 'spu_name', 
    tm_id string comment 'tm_id', 
    tm_name string comment 'tm_name'
) COMMENT '每日商品行为'
PARTITIONED BY ( dt  string)
stored as parquet
location '/warehouse/gmall/dws/dws_sku_action_daycount/'
tblproperties ("parquet.compression"="lzo");

drop table if exists dws_activity_info_daycount;
create external table dws_activity_info_daycount(
     id  string COMMENT '编号',
     activity_name  string  COMMENT '活动名称',
     activity_type  string  COMMENT '活动类型',
     start_time  string  COMMENT '开始时间',
     end_time  string  COMMENT '结束时间',
     create_time  string  COMMENT '创建时间',
     display_count  bigint COMMENT '曝光次数',
     order_count  bigint COMMENT '下单次数',
     order_amount  decimal(20,2) COMMENT '下单金额',
     payment_count  bigint COMMENT '支付次数',
     payment_amount  decimal(20,2) COMMENT '支付金额'
) COMMENT '每日活动统计'
PARTITIONED BY ( dt  string)
stored as parquet
location '/warehouse/gmall/dws/dws_activity_info_daycount/'
tblproperties ("parquet.compression"="lzo");

drop table if exists dws_area_stats_daycount;
create external table dws_area_stats_daycount(
     id  bigint COMMENT '编号',
     province_name  string COMMENT '省份名称',
     area_code  string COMMENT '地区编码',
     iso_code  string COMMENT 'iso编码',
     region_id  string COMMENT '地区ID',
     region_name  string COMMENT '地区名称',
     login_count  string COMMENT '活跃设备数',
     order_count  bigint COMMENT '下单次数',
     order_amount  decimal(20,2) COMMENT '下单金额',
     payment_count  bigint COMMENT '支付次数',
     payment_amount  decimal(20,2) COMMENT '支付金额'
) COMMENT '每日地区统计表'
PARTITIONED BY ( dt  string)
stored as parquet
location '/warehouse/gmall/dws/dws_area_stats_daycount/'
tblproperties ("parquet.compression"="lzo");

drop table if exists dwt_uv_topic;
create external table dwt_uv_topic
(
     mid_id  string comment '设备id',
     brand  string comment '手机品牌',
     model  string comment '手机型号',
     login_date_first  string  comment '首次活跃时间',
     login_date_last  string  comment '末次活跃时间',
     login_day_count  bigint comment '当日活跃次数',
     login_count  bigint comment '累积活跃天数'
) COMMENT '设备主题宽表'
partitioned by(dt string)
stored as parquet
location '/warehouse/gmall/dwt/dwt_uv_topic'
tblproperties ("parquet.compression"="lzo");

drop table if exists dwt_user_topic;
create external table dwt_user_topic
(
    user_id string  comment '用户id',
    login_date_first string  comment '首次登录时间',
    login_date_last string  comment '末次登录时间',
    login_count bigint comment '累积登录天数',
    login_last_30d_count bigint comment '最近30日登录天数',
    order_date_first string  comment '首次下单时间',
    order_date_last string  comment '末次下单时间',
    order_count bigint comment '累积下单次数',
    order_amount decimal(16,2) comment '累积下单金额',
    order_last_30d_count bigint comment '最近30日下单次数',
    order_last_30d_amount bigint comment '最近30日下单金额',
    payment_date_first string  comment '首次支付时间',
    payment_date_last string  comment '末次支付时间',
    payment_count decimal(16,2) comment '累积支付次数',
    payment_amount decimal(16,2) comment '累积支付金额',
    payment_last_30d_count decimal(16,2) comment '最近30日支付次数',
    payment_last_30d_amount decimal(16,2) comment '最近30日支付金额'
)COMMENT '会员主题宽表'
PARTITIONED BY ( dt  string)
stored as parquet
location '/warehouse/gmall/dwt/dwt_user_topic/'
tblproperties ("parquet.compression"="lzo");

drop table if exists dwt_sku_topic;
create external table dwt_sku_topic
(
    sku_id string comment 'sku_id',
    spu_id string comment 'spu_id',
    order_last_30d_count bigint comment '最近30日被下单次数',
    order_last_30d_num bigint comment '最近30日被下单件数',
    order_last_30d_amount decimal(16,2)  comment '最近30日被下单金额',
    order_count bigint comment '累积被下单次数',
    order_num bigint comment '累积被下单件数',
    order_amount decimal(16,2) comment '累积被下单金额',
    payment_last_30d_count   bigint  comment '最近30日被支付次数',
    payment_last_30d_num bigint comment '最近30日被支付件数',
    payment_last_30d_amount  decimal(16,2) comment '最近30日被支付金额',
    payment_count   bigint  comment '累积被支付次数',
    payment_num bigint comment '累积被支付件数',
    payment_amount  decimal(16,2) comment '累积被支付金额',
    refund_last_30d_count bigint comment '最近三十日退款次数',
    refund_last_30d_num bigint comment '最近三十日退款件数',
    refund_last_30d_amount decimal(16,2) comment '最近三十日退款金额',
    refund_count bigint comment '累积退款次数',
    refund_num bigint comment '累积退款件数',
    refund_amount decimal(16,2) comment '累积退款金额',
    cart_last_30d_count bigint comment '最近30日被加入购物车次数',
    cart_count bigint comment '累积被加入购物车次数',
    favor_last_30d_count bigint comment '最近30日被收藏次数',
    favor_count bigint comment '累积被收藏次数',
    appraise_last_30d_good_count bigint comment '最近30日好评数',
    appraise_last_30d_mid_count bigint comment '最近30日中评数',
    appraise_last_30d_bad_count bigint comment '最近30日差评数',
    appraise_last_30d_default_count bigint comment '最近30日默认评价数',
    appraise_good_count bigint comment '累积好评数',
    appraise_mid_count bigint comment '累积中评数',
    appraise_bad_count bigint comment '累积差评数',
    appraise_default_count bigint comment '累积默认评价数',
    sku_name string comment 'sku_name',
    spu_name string comment 'spu_name', 
    tm_id string comment 'tm_id',
    tm_name string comment 'tm_name'
 )COMMENT '商品主题宽表'
PARTITIONED BY ( dt  string)
stored as parquet
location '/warehouse/gmall/dwt/dwt_sku_topic/'
tblproperties ("parquet.compression"="lzo");

drop table if exists dwt_activity_topic;
create external table dwt_activity_topic(
     id  string COMMENT '编号',
     activity_name  string  COMMENT '活动名称',
     activity_type  string  COMMENT '活动类型',
     start_time  string  COMMENT '开始时间',
     end_time  string  COMMENT '结束时间',
     create_time  string  COMMENT '创建时间',
     display_day_count  bigint COMMENT '当日曝光次数',
     order_day_count  bigint COMMENT '当日下单次数',
     order_day_amount  decimal(20,2) COMMENT '当日下单金额',
     payment_day_count  bigint COMMENT '当日支付次数',
     payment_day_amount  decimal(20,2) COMMENT '当日支付金额',
     display_count  bigint COMMENT '累积曝光次数',
     order_count  bigint COMMENT '累积下单次数',
     order_amount  decimal(20,2) COMMENT '累积下单金额',
     payment_count  bigint COMMENT '累积支付次数',
     payment_amount  decimal(20,2) COMMENT '累积支付金额'
) COMMENT '活动主题宽表'
PARTITIONED BY ( dt  string)
stored as parquet
location '/warehouse/gmall/dwt/dwt_activity_topic/'
tblproperties ("parquet.compression"="lzo");

drop table if exists dwt_area_topic;
create external table dwt_area_topic(
     id  bigint COMMENT '编号',
     province_name  string COMMENT '省份名称',
     area_code  string COMMENT '地区编码',
     iso_code  string COMMENT 'iso编码',
     region_id  string COMMENT '地区ID',
     region_name  string COMMENT '地区名称',
     login_day_count  string COMMENT '当天活跃设备数',
     login_last_30d_count  string COMMENT '最近30天活跃设备数',
     order_day_count  bigint COMMENT '当天下单次数',
     order_day_amount  decimal(16,2) COMMENT '当天下单金额',
     order_last_30d_count  bigint COMMENT '最近30天下单次数',
     order_last_30d_amount  decimal(16,2) COMMENT '最近30天下单金额',
     payment_day_count  bigint COMMENT '当天支付次数',
     payment_day_amount  decimal(16,2) COMMENT '当天支付金额',
     payment_last_30d_count  bigint COMMENT '最近30天支付次数',
     payment_last_30d_amount  decimal(16,2) COMMENT '最近30天支付金额'
) COMMENT '地区主题宽表'
PARTITIONED BY ( dt  string)
stored as parquet
location '/warehouse/gmall/dwt/dwt_area_topic/'
tblproperties ("parquet.compression"="lzo");


drop table if exists ads_uv_count;
create external table ads_uv_count(
     dt  string COMMENT '统计日期',
     day_count  bigint COMMENT '当日用户数量',
     wk_count   bigint COMMENT '当周用户数量',
     mn_count   bigint COMMENT '当月用户数量',
     is_weekend  string COMMENT 'Y,N是否是周末,用于得到本周最终结果',
     is_monthend  string COMMENT 'Y,N是否是月末,用于得到本月最终结果' 
) COMMENT '活跃设备数'
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ads/ads_uv_count/';

drop table if exists ads_new_mid_count;
create external table ads_new_mid_count
(
     create_date      string comment '创建时间' ,
     new_mid_count    BIGINT comment '新增设备数量' 
)  COMMENT '每日新增设备数量'
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ads/ads_new_mid_count/';

drop table if exists ads_wastage_count;
create external table ads_wastage_count( 
     dt  string COMMENT '统计日期',
     wastage_count  bigint COMMENT '流失设备数'
) COMMENT '流失用户数'
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ads/ads_wastage_count';

drop table if exists ads_back_count;
create external table ads_back_count( 
     dt  string COMMENT '统计日期',
     wk_dt  string COMMENT '统计日期所在周',
     wastage_count  bigint COMMENT '回流设备数'
) COMMENT '本周回流用户数'
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ads/ads_back_count';

drop table if exists ads_continuity_uv_count;
create external table ads_continuity_uv_count( 
     dt  string COMMENT '统计日期',
     wk_dt  string COMMENT '最近7天日期',
     continuity_count  bigint
) COMMENT '最近七天内连续三天活跃用户数'
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ads/ads_continuity_uv_count';

drop table if exists ads_user_topic;
create external table ads_user_topic(
     dt  string COMMENT '统计日期',
     day_users  string COMMENT '活跃会员数',
     day_new_users  string COMMENT '新增会员数',
     day_new_payment_users  string COMMENT '新增消费会员数',
     payment_users  string COMMENT '总付费会员数',
     users  string COMMENT '总会员数',
     day_users2users  decimal(16,2) COMMENT '会员活跃率',
     payment_users2users  decimal(16,2) COMMENT '会员付费率',
     day_new_users2users  decimal(16,2) COMMENT '会员新鲜度'
  ) COMMENT '会员信息表'
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ads/ads_user_topic';

drop table if exists ads_user_action_convert_day;
create external  table ads_user_action_convert_day(
     dt  string COMMENT '统计日期',
     home_count   bigint COMMENT '浏览首页人数',
     good_detail_count  bigint COMMENT '浏览商品详情页人数',
     home2good_detail_convert_ratio  decimal(16,2) COMMENT '首页到商品详情转化率',
     cart_count  bigint COMMENT '加入购物车的人数',
     good_detail2cart_convert_ratio  decimal(16,2) COMMENT '商品详情页到加入购物车转化率',
     order_count  bigint     COMMENT '下单人数',
     cart2order_convert_ratio   decimal(16,2) COMMENT '加入购物车到下单转化率',
     payment_amount  bigint     COMMENT '支付人数',
     order2payment_convert_ratio  decimal(16,2) COMMENT '下单到支付的转化率'
  ) COMMENT '漏斗分析'
row format delimited  fields terminated by '\t'
location '/warehouse/gmall/ads/ads_user_action_convert_day/';

drop table if exists ads_product_sale_topN;
create external table ads_product_sale_topN(
     dt  string COMMENT '统计日期',
 sku_id  string COMMENT '商品ID',
 sku_name  string COMMENT '商品名称',
     payment_amount  bigint COMMENT '销量'
) COMMENT '商品销量排名'
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ads/ads_product_sale_topN';

drop table if exists ads_product_cart_topN;
create external table ads_product_cart_topN(
     dt  string COMMENT '统计日期',
 sku_id  string COMMENT '商品ID',
 sku_name  string COMMENT '商品名称',
     cart_count  bigint COMMENT '加入购物车次数'
) COMMENT '商品加入购物车排名'
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ads/ads_product_cart_topN';

drop table if exists ads_trademark_sale;
create external table ads_trademark_sale(
     dt  string COMMENT '统计日期',
     tm_name  string COMMENT '品牌名称',
     payment_num  bigint COMMENT '销售量', 
     payment_amount  bigint COMMENT '销售额'
) COMMENT '品牌销量'
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ads/ads_trademark_sale';

drop table if exists ads_spu_sale;
create external table ads_spu_sale(
     dt  string COMMENT '统计日期',
     tm_name  string COMMENT '品牌名称',
     spu_name  string COMMENT 'spu名称',
     payment_num  bigint COMMENT '销售量', 
     payment_amount  bigint COMMENT '销售额'
) COMMENT '品牌销量'
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ads/ads_spu_sale';

drop table if exists ads_trademark_appraise;
create external table ads_trademark_appraise(
     dt  string COMMENT '统计日期',
     tm_name  string COMMENT '商品ID',
     appraise_last_30d_good_ratio  decimal(16,2) COMMENT '最近30天好评率',
     appraise_last_30d_bad_ratio  decimal(16,2) COMMENT '最近30天差评率'
) COMMENT '品牌评价'
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ads/ads_trademark_appraise';

drop table if exists ads_order_daycount;
create external table ads_order_daycount(
    dt string comment '统计日期',
    order_count bigint comment '单日下单笔数',
    order_amount bigint comment '单日下单金额',
    order_users bigint comment '单日下单用户数'
) comment '下单数目统计'
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ads/ads_order_daycount';

drop table if exists ads_payment_daycount;
create external table ads_payment_daycount(
    dt string comment '统计日期',
    order_count bigint comment '单日支付笔数',
    order_amount bigint comment '单日支付金额',
    payment_user_count bigint comment '单日支付人数',
    payment_sku_count bigint comment '单日支付商品数',
    payment_avg_time decimal(16,2) comment '下单到支付的平均时长，取分钟数'
) comment '支付信息统计'
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ads/ads_payment_daycount';

drop table if exists ads_area_topic;
create external table ads_area_topic(
     dt  string COMMENT '统计日期',
     id  string COMMENT '编号',
     province_name  string COMMENT '省份名称',
     area_code  string COMMENT '地区编码',
     iso_code  string COMMENT 'iso编码',
     region_id  string COMMENT '地区ID',
     region_name  string COMMENT '地区名称',
     login_day_count  bigint COMMENT '当天活跃设备数',
     order_day_count  bigint COMMENT '当天下单次数',
     order_day_amount  decimal(16,2) COMMENT '当天下单总量',
     payment_day_count  bigint COMMENT '当天支付次数',
     payment_day_amount  decimal(16,2) COMMENT '当天支付总金额',
     successful_pay_rate  decimal(16,2) COMMENT '成功下单率',
     user_purchase_rate  decimal(16,2) COMMENT '用户购买率'
) COMMENT '地区主题信息'
row format delimited fields terminated by '\t'
location '/warehouse/gmall/ads/ads_area_topic/';
