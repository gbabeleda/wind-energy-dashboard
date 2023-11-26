with
    feature_wind_hourly as (select * from {{ ref("feature_wind_hourly") }}),

    max_wind_speed_hourly as (
        select ceil(max(avg_wind_speed)) as max_speed from feature_wind_hourly
    ),

    binned_speed_hourly as (
        select
            fwh.years,
            fwh.months,
            fwh.year_month,
            fwh.days,
            fwh.hours,

            cast(
                case
                    when
                        ceil(fwh.avg_wind_speed / mwsh.max_speed * (mwsh.max_speed - 1))
                        = 0
                    then 1
                    else ceil(fwh.avg_wind_speed / mwsh.max_speed * (mwsh.max_speed))
                end as int64
            ) as speed_bin,

            fwh.avg_wind_speed

        from feature_wind_hourly as fwh
        cross join max_wind_speed_hourly as mwsh

        order by 1, 2, 3, 4, 5
    )

select *
from binned_speed_hourly


