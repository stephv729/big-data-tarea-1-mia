with source as (

    select *
    from {{ source('rds_mysql', 'customer_dim') }}
    where coalesce(_fivetran_deleted, false) = false

)

select
    customer_id,
    customer_name,
    region,
    sex                       as gender,
    age,
    nacionality               as nationality,
    cast(join_date as date)   as join_date,
    _fivetran_synced          as _synced_at
from source
