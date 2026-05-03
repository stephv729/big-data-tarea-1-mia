-- TODO: ajustar columnas segun el esquema real de la tabla product_dim en Airtable.
-- Ejecuta primero `dbt compile` o revisa el dataset en BigQuery para confirmar nombres.

with source as (

    select *
    from {{ source('airtable', 'product_dim') }}
    where coalesce(_fivetran_deleted, false) = false

)

select
    product_id,
    product_name,
    category,
    price,
    _fivetran_synced as _synced_at
from source
