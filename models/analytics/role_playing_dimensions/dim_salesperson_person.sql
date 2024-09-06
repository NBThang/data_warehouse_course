WITH dim_salesperson_person__source as (
  select
    *
  from `vit-lam-data.wide_world_importers.application__people`
)

, dim_salesperson_person__rename_column as (
  select
    person_id as person_key,
    full_name,
  from dim_salesperson_person__source
)

, dim_salesperson_person__cast_type as (
  select
    CAST(person_key as INTEGER) as person_key,
    CAST(full_name as STRING) as full_name
  from dim_salesperson_person__rename_column
)

, dim_salesperson_person__add_underfined_record as (
SELECT 
  person_key,
  full_name
FROM dim_salesperson_person__cast_type

-- Thêm dữ liệu 0|'Underfind'
UNION ALL
select 
  0 as person_key,
  'Underfined' as full_name  

-- Thêm dữ liệu 0|'Underfind'
UNION ALL
select 
  -1 as person_key,
  'Invalid' as full_name  
)
 
SELECT 
  person_key,
  full_name
FROM dim_salesperson_person__add_underfined_record
