WITH dim_person__source as (
  select
    *
  from `vit-lam-data.wide_world_importers.application__people`
)

, dim_person__rename_column as (
  select
    person_id as person_key,
    full_name,
  from dim_person__source
)

, dim_person__cast_type as (
  select
    CAST(person_key as INTEGER) as person_key,
    CAST(full_name as STRING) as full_name
  from dim_person__rename_column
)

SELECT 
  person_key,
  full_name
FROM dim_person__cast_type
