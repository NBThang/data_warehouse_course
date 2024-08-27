WITH dim_group__source as (
  SELECT 
  *
  FROM `vit-lam-data.wide_world_importers.sales__buying_groups`
)

, dim_group__rename_column as (
  select
  buying_group_id as buying_group_key,
  buying_group_name 
  from dim_group__source
)

, dim_group__cast_type as (
  select 
  CAST(buying_group_key as INTEGER) as buying_group_key,
  CAST(buying_group_name as STRING) as buying_group_name
  from dim_group__rename_column
)

select 
  buying_group_key,
  buying_group_name
from dim_group__cast_type