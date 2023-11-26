{# Features aggregated by hour#}
with
    feature_wind as (select * from {{ ref("feature_wind") }}),

    feature_wind_hourly as (

        select
            years,
            months,
            year_month,
            days,
            hours,

            round(avg(wind_speed), 4) as avg_wind_speed,
            round(avg(wind_direction), 4) as avg_wind_direction

        from feature_wind

        group by 1, 2, 3, 4, 5

        order by 1, 2, 3, 4, 5
    )

select *
from feature_wind_hourly
