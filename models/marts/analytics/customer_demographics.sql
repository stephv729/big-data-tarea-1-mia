-- Q5: Como se distribuye la edad / sexo / nacionalidad de los clientes?
-- Grano: una fila por cliente con buckets demograficos + metricas de compra
-- (utiles para cruces tipo "edad vs revenue" en PBI / Looker).

{{ config(materialized='table') }}

select
    c.customer_id,
    c.customer_name,
    c.region,
    c.gender,
    c.age,
    case
        when c.age < 25 then '18-24'
        when c.age < 35 then '25-34'
        when c.age < 45 then '35-44'
        when c.age < 55 then '45-54'
        when c.age < 65 then '55-64'
        else '65+'
    end                              as age_group,
    c.nationality,
    c.join_date,
    coalesce(count(s.date_id), 0)    as num_transactions,
    coalesce(sum(s.quantity), 0)     as total_units,
    coalesce(sum(s.total_sales), 0.0) as total_spent
from {{ ref('dim_customer') }} c
left join {{ ref('fact_sales') }} s using (customer_id)
group by 1, 2, 3, 4, 5, 6, 7, 8
