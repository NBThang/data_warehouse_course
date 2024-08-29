WITH dim_customer__source AS (
  select *
  from `vit-lam-data.wide_world_importers.sales__customers`
)

, dim_customer__rename_column as (
  select
    buying_group_id as buying_group_key,
    customer_category_id as customer_category_key,
    customer_id as customer_key,
    customer_name as customer_name,
    is_on_credit_hold
  from dim_customer__source
)

, dim_customer__cast_type as (
  select
    CAST(buying_group_key as INTEGER) as buying_group_key,
    CAST(customer_category_key as INTEGER) as customer_category_key,
    CAST(customer_key as INTEGER) as customer_key,
    CAST(customer_name as STRING) as customer_name,
    CAST(is_on_credit_hold as BOOLEAN) as is_on_credit_hold_boolean
  from dim_customer__rename_column
)

, dim_customer__convert_boolean as (
  select
  *,
  CASE
    WHEN is_on_credit_hold_boolean is TRUE then 'On Credit Hold'
    WHEN is_on_credit_hold_boolean is FALSE then 'Not On Credit Hold'
    WHEN is_on_credit_hold_boolean is NULL then 'Underfined'
    ELSE 'Invalid' END
  as is_on_credit_hold
  from dim_customer__cast_type
)

, dim_customer__add_underfined_recored as (
  select
    customer_key,
    buying_group_key,
    customer_category_key,
    customer_name,
    is_on_credit_hold
  from dim_customer__convert_boolean

  UNION ALL
  select 
    0 as customer_key,
    0 as buying_group_key,
    0 as customer_category_key,
    'Underfined' as customer_name,
    'Underfined' as is_on_credit_hold

  UNION ALL
  select 
    -1 as customer_key,
    -1 as buying_group_key,
    -1 as customer_category_key,
    'Invalid' as customer_name,
    'Invalid' as is_on_credit_hold
)


SELECT 
  dim_customer.customer_key,
  dim_customer.customer_name,
  dim_customer.customer_category_key,
  COALESCE(dim_category.customer_category_name, 'Invalid') as customer_category_name,
  dim_customer.buying_group_key,
  COALESCE(dim_group.buying_group_name, 'Invalid') as buying_group_name,
  dim_customer.is_on_credit_hold

FROM dim_customer__add_underfined_recored as dim_customer

LEFT JOIN {{ref('stg_dim_group')}} as dim_group
  ON dim_customer.buying_group_key = dim_group.buying_group_key

LEFT JOIN {{ ref('stg_dim_category') }} as dim_category
  ON dim_customer.customer_category_key = dim_category.customer_category_key
