-- Q3: Hay productos cuya venta ha caido en el tiempo?
-- Grano: (mes, producto) con tendencia mes-a-mes (revenue_change_pct < 0 = caida).
-- Util para detectar productos en declive.

{{ config(materialized='table') }}

with monthly as (

    select
        date_trunc(s.date_id, month) as month_start,
        p.product_id,
        p.product_name,
        p.category,
        p.brand,
        sum(s.quantity)    as units_sold,
        sum(s.total_sales) as revenue
    from {{ ref('fact_sales') }} s
    left join {{ ref('dim_product') }} p using (product_id)
    group by 1, 2, 3, 4, 5

)

select
    month_start,
    product_id,
    product_name,
    category,
    brand,
    units_sold,
    revenue,
    lag(revenue) over (partition by product_id order by month_start) as prev_month_revenue,
    revenue - lag(revenue) over (partition by product_id order by month_start) as revenue_change,
    safe_divide(
        revenue - lag(revenue) over (partition by product_id order by month_start),
        lag(revenue) over (partition by product_id order by month_start)
    ) as revenue_change_pct
from monthly
