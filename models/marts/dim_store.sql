{{ config(materialized='table') }}

select
    store_id,
    store_name,
    city,
    country
from {{ ref('stg_stores') }}
