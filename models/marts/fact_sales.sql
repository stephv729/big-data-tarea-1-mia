{{ config(materialized='table') }}

select
    date_id,
    product_id,
    customer_id,
    store_id,
    quantity,
    unit_price,
    total_sales
from {{ ref('stg_sales') }}
