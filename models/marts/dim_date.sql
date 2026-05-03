{{ config(materialized='table') }}

select
    date_id,
    full_date,
    day,
    month,
    quarter,
    year,
    day_of_week
from {{ ref('stg_dates') }}
