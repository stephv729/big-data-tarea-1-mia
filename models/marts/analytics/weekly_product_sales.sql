-- Q1: Cuales son los productos mas vendidos semana a semana?
-- Grano: una fila por (semana, producto). Ordenable por unidades o revenue.

{{ config(materialized='table') }}

select
    date_trunc(s.date_id, week(monday)) as week_start,
    p.product_id,
    p.product_name,
    p.category,
    p.brand,
    sum(s.quantity)    as units_sold,
    sum(s.total_sales) as revenue,
    count(*)           as num_transactions
from {{ ref('fact_sales') }} s
left join {{ ref('dim_product') }} p using (product_id)
group by 1, 2, 3, 4, 5
