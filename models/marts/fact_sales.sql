{{ config(materialized='table') }}

with sales as (
    select * from {{ ref('stg_sales') }}
)

select
    s.sale_id,
    s.customer_id,
    s.product_id,
    s.store_id,
    s.date_id,
    s.quantity,
    s.amount,
    s.amount * 1.0 as total_amount   -- placeholder por si quieres calculos derivados
from sales s
left join {{ ref('dim_customer') }} c using (customer_id)
left join {{ ref('dim_product')  }} p using (product_id)
left join {{ ref('dim_store')    }} st using (store_id)
left join {{ ref('dim_date')     }} d using (date_id)
