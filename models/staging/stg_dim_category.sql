WITH dim_category__source as (
  SELECT
   *
  FROM `vit-lam-data.wide_world_importers.sales__customer_categories`
)

, dim_category__rename_column as (
  select
  customer_category_id as customer_category_key,
  customer_category_name
  from dim_category__source
)

, dim_category__cast_type as (
  select 
  CAST(customer_category_key as INTEGER) as customer_category_key,
  CAST(customer_category_name as STRING) as customer_category_name
  from dim_category__rename_column
)

, dim_category__add_underfined_record as (
  select 
    customer_category_key,
    customer_category_name
  from dim_category__cast_type

  UNION ALL 
  select 
    0 as customer_category_key,
    'Underfined' as customer_category_name

  UNION ALL 
  select 
    -1 as customer_category_key,
    'Invalid' as customer_category_name
)
SELECT 
  customer_category_key,
  customer_category_name
FROM dim_category__add_underfined_record