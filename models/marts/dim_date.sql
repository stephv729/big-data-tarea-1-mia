{{ config(materialized='table') }}

select
    date_id,
    day,
    month,
    month_name,
    quarter,
    year,
    weekday_name,
    is_weekend
from {{ ref('stg_dates') }}
