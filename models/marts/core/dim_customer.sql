{{ config(materialized='table') }}

select
    customer_id,
    customer_name,
    region,
    gender,
    age,
    nationality,
    join_date
from {{ ref('stg_customers') }}
