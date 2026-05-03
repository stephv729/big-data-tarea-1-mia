-- Q4: Como varia el volumen vendido en el tiempo?
-- Grano: una fila por dia con metricas + buckets de semana/mes/trimestre para drill-down.

{{ config(materialized='table') }}

select
    s.date_id                                as sale_date,
    date_trunc(s.date_id, week(monday))     as week_start,
    date_trunc(s.date_id, month)            as month_start,
    date_trunc(s.date_id, quarter)          as quarter_start,
    extract(year from s.date_id)            as year,
    d.weekday_name,
    d.is_weekend,
    sum(s.quantity)                         as units_sold,
    sum(s.total_sales)                      as revenue,
    count(*)                                as num_transactions,
    count(distinct s.customer_id)           as unique_customers,
    count(distinct s.product_id)            as unique_products
from {{ ref('fact_sales') }} s
left join {{ ref('dim_date') }} d using (date_id)
group by 1, 2, 3, 4, 5, 6, 7
