WITH dim_product__source AS (
  SELECT *
  FROM `vit-lam-data.wide_world_importers.warehouse__stock_items`
)

, dim_product__rename_column AS (
  SELECT 
    stock_item_id AS product_key,
    stock_item_name AS product_name,
    supplier_id as supplier_key,
    brand AS brand_name,
    is_chiller_stock
  FROM dim_product__source
)

, dim_product__cast_type AS (
  SELECT 
    CAST(product_key AS INTEGER) AS product_key,
    CAST(product_name AS STRING) AS product_name,
    CAST(supplier_key as INTEGER) as supplier_key,
    CAST(brand_name AS STRING) AS brand_name,
    CAST(is_chiller_stock AS BOOLEAN) AS is_chiller_stock_boolean
  FROM dim_product__rename_column
)

, dim_product__convert_boolean as (
  SELECT
  *,
  CASE
    WHEN is_chiller_stock_boolean IS TRUE then 'Chiller Stock'
    WHEN is_chiller_stock_boolean IS FALSE then 'Not Chiller Stock'
    WHEN is_chiller_stock_boolean IS NULL then 'Underfined'
    ELSE 'Invalid' END
  as is_chiller_stock
  FROM dim_product__cast_type
)

SELECT 
  dim_product.product_key,
  dim_product.product_name,
  dim_product.supplier_key,
  COALESCE(dim_supplier.supplier_name, 'Invalid') as supplier_name,
  COALESCE(dim_product.brand_name, 'Underfined') as brand_name,
  dim_product.is_chiller_stock
FROM dim_product__convert_boolean AS dim_product
LEFT JOIN {{ ref ('dim_supplier') }} as dim_supplier
ON dim_product.supplier_key = dim_supplier.supplier_key
