{# Feature Engineering (?) #}
with
    stg_wind as (

        select date_time, wind_speed, wind_direction from {{ ref("stg_wind") }}

    ),

    date_time_features as (

        select
            extract(year from date_time) as years,
            extract(month from date_time) as months,
            format_timestamp('%Y-%B', date_time) as year_month,
            extract(day from date_time) as days,
            extract(hour from date_time) + 1 as hours,

            wind_speed,
            wind_direction

        from stg_wind

        order by 1, 2, 4, 5
    )

select *
from date_time_features
