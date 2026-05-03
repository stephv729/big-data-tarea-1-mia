with source as (

    select *
    from {{ source('gdrive', 'sales_fact_hoja_1') }}

)

select
    cast(date_id as date) as date_id,
    product_id,
    customer_id,
    store_id,
    quantity,
    unit_price,
    total_sales,
    _fivetran_synced as _synced_at
from source
