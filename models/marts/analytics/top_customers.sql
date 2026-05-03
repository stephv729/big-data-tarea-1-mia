-- Q2: Cual es el cliente que compra mas?
-- Grano: una fila por cliente con sus metricas agregadas. Ordenar por total_spent DESC para ranking.

{{ config(materialized='table') }}

select
    c.customer_id,
    c.customer_name,
    c.region,
    c.gender,
    c.age,
    c.nationality,
    coalesce(count(s.date_id), 0)    as num_transactions,
    coalesce(sum(s.quantity), 0)      as total_units,
    coalesce(sum(s.total_sales), 0.0) as total_spent,
    coalesce(avg(s.total_sales), 0.0) as avg_ticket,
    min(s.date_id) as first_purchase,
    max(s.date_id) as last_purchase
from {{ ref('dim_customer') }} c
left join {{ ref('fact_sales') }} s using (customer_id)
group by 1, 2, 3, 4, 5, 6
