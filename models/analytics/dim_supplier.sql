WITH dim_supplier__source AS (
  SELECT *
  FROM `vit-lam-data.wide_world_importers.purchasing__suppliers`
)

, dim_supplier__rename_column as (
  SELECT 
  supplier_id AS supplier_key,
  supplier_name as supplier_name
  from dim_supplier__source
  
)

, dim_supplier__cast_type as (
  select
  CAST(supplier_key as INTEGER) as supplier_key,
  CAST(supplier_name as STRING) as supplier_name
  from
  dim_supplier__rename_column
)
SELECT 
  supplier_key,
  supplier_name
FROM dim_supplier__cast_type
