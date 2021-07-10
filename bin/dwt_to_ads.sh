#!/bin/bash

hive=$HIVE_HOME/bin/hive
APP=gmall
# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [[ $1 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    do_date=$1
else 
    do_date=`date -d "-1 day" +%F`
fi

sql="
use ${APP};
insert into table ads_uv_count 
select  
    '$do_date' dt,
    daycount.ct,
    wkcount.ct,
    mncount.ct,
    if(date_add(next_day('$do_date','MO'),-1)='$do_date','Y','N') ,
    if(last_day('$do_date')='$do_date','Y','N') 
from 
(
    select  
        '$do_date' dt,
        count(*) ct
    from (
        select * from dwt_uv_topic
        where dt='$do_date'
    )t
    where t.login_date_last='$do_date'  
)daycount join 
( 
    select  
        '$do_date' dt,
        count (*) ct
    from (
        select * from dwt_uv_topic
        where dt='$do_date'
    )t
    where t.login_date_last>=date_add(next_day('$do_date','MO'),-7) 
    and t.login_date_last<= date_add(next_day('$do_date','MO'),-1) 
) wkcount on daycount.dt=wkcount.dt
join 
( 
    select  
        '$do_date' dt,
        count (*) ct
    from (
        select * from dwt_uv_topic
        where dt='$do_date'
    )t
    where date_format(t.login_date_last,'yyyy-MM')=date_format('$do_date','yyyy-MM')  
)mncount on daycount.dt=mncount.dt;

insert into table ads_new_mid_count 
select
    '$do_date',
    count(*)
from (
    select * from dwt_uv_topic
    where dt='$do_date'
)t
where t.login_date_first='$do_date';

insert into table ads_wastage_count
select
     '$do_date',
     count(*)
from 
(
    select 
        mid_id
    from (
        select * from dwt_uv_topic
        where dt='$do_date'
    ) t
    where t.login_date_last<=date_add('$do_date',-7)
    group by mid_id
)t1;

insert into table ads_back_count
select
    '$do_date',
    concat(date_add(next_day('$do_date','MO'),-7),'_', date_add(next_day('$do_date','MO'),-1)),
    count(*)
from
(
    select
        mid_id
    from (
        select * from dwt_uv_topic
        where dt='$do_date'
    )t
    where t.login_date_last>=date_add(next_day('$do_date','MO'),-7) 
    and t.login_date_last<= date_add(next_day('$do_date','MO'),-1)
    and t.login_date_first<date_add(next_day('$do_date','MO'),-7)
)current_wk
left join
(
    select
        mid_id
    from dws_uv_detail_daycount
    where dt>=date_add(next_day('$do_date','MO'),-7*2) 
    and dt<= date_add(next_day('$do_date','MO'),-7-1) 
    group by mid_id
)last_wk
on current_wk.mid_id=last_wk.mid_id
where last_wk.mid_id is null;

insert into table ads_continuity_uv_count
select
    '$do_date',
    concat(date_add('$do_date',-6),'_','$do_date'),
    count(*)
from
(
    select mid_id
    from
    (
        select mid_id
        from
        (
            select 
                mid_id,
                date_sub(dt,rank) date_dif
            from
            (
                select
                    mid_id,
                    dt,
                    rank() over(partition by mid_id order by dt) rank
                from dws_uv_detail_daycount
                where dt>=date_add('$do_date',-6) and dt<='$do_date'
            )t1
        )t2 
        group by mid_id,date_dif
        having count(*)>=3
    )t3 
    group by mid_id
)t4;

insert into table ads_user_topic
select
    '$do_date',
    sum(if(login_date_last='$do_date',1,0)),
    sum(if(login_date_first='$do_date',1,0)),
    sum(if(payment_date_first='$do_date',1,0)),
    sum(if(payment_count>0,1,0)),
    count(*),
    sum(if(login_date_last='$do_date',1,0))/count(*),
    sum(if(payment_count>0,1,0))/count(*),
    sum(if(login_date_first='$do_date',1,0))/sum(if(login_date_last='$do_date',1,0))
from dwt_user_topic
where dt='$do_date';

with
tmp_uv as
  (
    select
      '$do_date' dt,
      sum(if(array_contains(pages,'home'),1,0)) home_count,
      sum(if(array_contains(pages,'good_detail'),1,0)) good_detail_count
    from
    (
      select
        mid_id,
        collect_set(page_id) pages
      from dwd_page_log
      where dt='$do_date'
      and page_id in ('home','good_detail')
      group by mid_id
    )tmp
  ),
  tmp_cop as
  (
    select 
      '$do_date' dt,
      sum(if(cart_count>0,1,0)) cart_count,
      sum(if(order_count>0,1,0)) order_count,
      sum(if(payment_count>0,1,0)) payment_count
    from dws_user_action_daycount
    where dt='$do_date'
  )
insert into table ads_user_action_convert_day
select
    tmp_uv.dt,
    tmp_uv.home_count,
    tmp_uv.good_detail_count,
    tmp_uv.good_detail_count/tmp_uv.home_count*100,
    tmp_cop.cart_count,
    tmp_cop.cart_count/tmp_uv.good_detail_count*100,
    tmp_cop.order_count,
    tmp_cop.order_count/tmp_cop.cart_count*100,
    tmp_cop.payment_count,
    tmp_cop.payment_count/tmp_cop.order_count*100
from tmp_uv
join tmp_cop
on tmp_uv.dt=tmp_cop.dt;

with 
tmp_sale as
(select
    '$do_date' dt,
sku_id,
payment_amount
from
dws_sku_action_daycount
where
    dt='$do_date'
order by payment_amount desc
limit 10
)
insert into table ads_product_sale_topN
select
    '$do_date' dt,
sku_id,
sku_name,
    payment_amount
from
tmp_sale left join dwd_dim_sku_info
where
tmp_sale.sku_id = dwd_dim_sku_info.id and dwd_dim_sku_info.dt='$do_date';

with tmp_cart as
(
select
    '$do_date' dt,
    sku_id,
    cart_count
from
    dws_sku_action_daycount
where
    dt='$do_date'
order by cart_count desc
limit 10
)
insert into table ads_product_cart_topN
select
    '$do_date' dt,
sku_id,
sku_name,
    cart_count
from
    tmp_cart left join dwd_dim_sku_info
where
tmp_cart.sku_id = dwd_dim_sku_info.id and dwd_dim_sku_info.dt='$do_date';

insert into table ads_trademark_sale
select
    '$do_date' dt,
    tm_name,
    sum(payment_num),
    sum(payment_amount)
from
    dws_sku_action_daycount
where
    dt='$do_date'
group by
    tm_name;

insert into table ads_spu_sale
select
    '$do_date' dt,
    tm_name,
    spu_name,
    sum(payment_num),
    sum(payment_amount)
from
    dws_sku_action_daycount
where
    dt='$do_date'
group by
    tm_name, spu_name;

insert into table ads_trademark_appraise
select
    '$do_date' dt,
    tm_name,
sum(appraise_last_30d_good_count/(appraise_last_30d_good_count+appraise_last_30d_mid_count+appraise_last_30d_bad_count+appraise_last_30d_default_count)) appraise_last_30d_good_ratio,
sum(appraise_last_30d_bad_count/(appraise_last_30d_good_count+appraise_last_30d_mid_count+appraise_last_30d_bad_count+appraise_last_30d_default_count)) appraise_last_30d_bad_ratio
from
    dwt_sku_topic
where
    dt='$do_date'
group by
    tm_name;

insert into table ads_order_daycount
select
    '$do_date',
    sum(order_count),
    sum(order_amount),
    sum(if(order_count>0,1,0))
from dws_user_action_daycount
where dt='$do_date';

insert into table ads_payment_daycount
select
    tmp_payment.dt,
    tmp_payment.payment_count,
    tmp_payment.payment_amount,
    tmp_payment.payment_user_count,
    tmp_skucount.payment_sku_count,
    tmp_time.payment_avg_time
from
(
    select
        '$do_date' dt,
        sum(payment_count) payment_count,
        sum(payment_amount) payment_amount,
        sum(if(payment_count>0,1,0)) payment_user_count
    from dws_user_action_daycount
    where dt='$do_date'
)tmp_payment
join
(
    select
        '$do_date' dt,
        sum(if(payment_count>0,1,0)) payment_sku_count 
    from dws_sku_action_daycount
    where dt='$do_date'
)tmp_skucount on tmp_payment.dt=tmp_skucount.dt
join
(
    select
        '$do_date' dt,
        sum(unix_timestamp(payment_time)-unix_timestamp(create_time))/count(*)/60 payment_avg_time
    from dwd_fact_order_info
    where dt='$do_date'
    and payment_time is not null
)tmp_time on tmp_payment.dt=tmp_time.dt;

insert into table ads_area_topic
select
    '$do_date',
    id,
    province_name,
    area_code,
    iso_code,
    region_id,
    region_name,
    login_day_count,
    order_day_count,
    order_day_amount,
    payment_day_count,
    payment_day_amount,
    nvl(payment_day_count / order_day_count, 0),
    nvl(order_day_count / login_day_count, 0)
from dwt_area_topic where dt='$do_date';
"

$hive -e "$sql"

