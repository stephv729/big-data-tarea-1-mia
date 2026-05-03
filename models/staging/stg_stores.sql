with source as (

    select *
    from {{ source('gsheets', 'store_dim') }}

)

select
    store_id,
    store_name,
    city,
    cast(open_since as date) as open_since,
    _fivetran_synced as _synced_at
from source
