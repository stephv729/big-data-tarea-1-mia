-- TODO: ajustar columnas segun el esquema real de sales_fact_hoja_1.

with source as (

    select *
    from {{ source('gdrive', 'sales_fact_hoja_1') }}
    where coalesce(_fivetran_deleted, false) = false

)

select
    sale_id,
    customer_id,
    product_id,
    store_id,
    date_id,
    quantity,
    amount,
    _fivetran_synced as _synced_at
from source
