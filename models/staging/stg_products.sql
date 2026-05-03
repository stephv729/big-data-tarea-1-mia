with source as (

    select *
    from {{ source('airtable', 'product_dim') }}

)

select
    product_id,
    product_name,
    category,
    brand,
    _fivetran_synced as _synced_at
from source
