-- TODO: ajustar columnas segun el esquema real de date_dim_hoja_1.

with source as (

    select *
    from {{ source('gdrive', 'date_dim_hoja_1') }}
    where coalesce(_fivetran_deleted, false) = false

)

select
    date_id,
    cast(full_date as date) as full_date,
    day,
    month,
    quarter,
    year,
    day_of_week,
    _fivetran_synced as _synced_at
from source
