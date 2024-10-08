with fact_sales_order__source as (
  select *
  from `vit-lam-data.wide_world_importers.sales__orders`
)

, fact_sales_order__rename_column as (
  select
    order_id as sales_order_key,
    customer_id as customer_key,
    picked_by_person_id as picked_by_person_key,
    order_date
  from fact_sales_order__source
)

, fact_sales_order__cast_type as (
  select
    CAST(sales_order_key as INTEGER) as sales_order_key,
    CAST(customer_key as INTEGER) as customer_key,
    CAST(picked_by_person_key as INTEGER) as picked_by_person_key,
    CAST(order_date as DATE) as order_date
  from fact_sales_order__rename_column
)

select 
  sales_order_key,
  COALESCE(customer_key, 0) as customer_key,
  COALESCE(picked_by_person_key, 0) as picked_by_person_key,
  order_date
from fact_sales_order__cast_type