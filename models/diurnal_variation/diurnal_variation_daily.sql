with
    feature_wind_hourly as (select * from {{ ref("feature_wind_hourly") }}),
    
    diurnal_daily as (

        select
            years,
            months,
            year_month,
            days,
            hours,

            round(avg_wind_speed, 3) as avg_wind_speed

        from feature_wind_hourly

        order by 1, 2, 3, 4, 5
    )

select *
from diurnal_daily
