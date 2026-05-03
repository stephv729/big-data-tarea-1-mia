-- TODO: ajustar columnas segun el esquema real de store_dim en Google Sheets.

with source as (

    select *
    from {{ source('gsheets', 'store_dim') }}
    where coalesce(_fivetran_deleted, false) = false

)

select
    store_id,
    store_name,
    city,
    country,
    _fivetran_synced as _synced_at
from source
