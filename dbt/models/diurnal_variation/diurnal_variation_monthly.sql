with
    feature_wind_hourly as (select * from {{ ref("feature_wind_hourly") }}),

    diurnal_monthly as (
        
        select
            years,
            months,
            year_month,
            hours,

            round(avg(avg_wind_speed), 3) as avg_wind_speed

        from feature_wind_hourly

        group by 1, 2, 3, 4

        order by 1, 2, 3, 4
    )

select *
from diurnal_monthly
