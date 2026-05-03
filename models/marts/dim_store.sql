{{ config(materialized='table') }}

select
    store_id,
    store_name,
    city,
    open_since
from {{ ref('stg_stores') }}
