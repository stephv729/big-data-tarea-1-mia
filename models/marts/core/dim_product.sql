{{ config(materialized='table') }}

select
    product_id,
    product_name,
    category,
    brand
from {{ ref('stg_products') }}
