WITH dim_date__source as (
SELECT 
  DATE_ADD('2010-01-01', INTERVAL n DAY) AS date
FROM 
  UNNEST(GENERATE_ARRAY(0, DATE_DIFF('2030-12-31', '2010-01-01', DAY))) AS n
)

SELECT 
  date,
  FORMAT_DATETIME('%A', DATETIME(date)) AS day_of_week,
  FORMAT_DATETIME('%a', DATETIME(date)) AS day_of_week_short,

  CASE
    WHEN EXTRACT(DAYOFWEEK FROM TIMESTAMP(date)) IN (1, 7) THEN 'Weekend'
    ELSE 'Weekday'
  END AS is_weekday_or_weekend,

  DATE_TRUNC(date, MONTH) AS year_month,
  EXTRACT(MONTH FROM date) AS month,
  DATE_TRUNC(date, YEAR) AS year,
  EXTRACT(YEAR FROM date) AS year_number

from dim_date__source