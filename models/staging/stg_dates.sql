with source as (

    select *
    from {{ source('gdrive', 'date_dim_hoja_1') }}

)

select
    cast(date_id as date) as date_id,
    day,
    month,
    month_name,
    quarter,
    year,
    weekday_name,
    is_weekend,
    _fivetran_synced as _synced_at
from source
