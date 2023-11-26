with
    feature_wind_hourly as (select * from {{ ref("feature_wind_hourly") }}),

    binned_speed_hourly as (select * from {{ ref("binned_speed_hourly") }}),

    joined_filtered as (
        select
            years,
            months,
            year_month,
            days,
            hours,

            bsh.speed_bin,

            avg_wind_speed,

            fwh.avg_wind_direction,

        from feature_wind_hourly as fwh

        join
            binned_speed_hourly as bsh using (
                years, months, year_month, days, hours, avg_wind_speed
            )

        where avg_wind_speed > 0
    ),
    
    cardinal_directions_hourly as (
        select
            years,
            months,
            year_month,
            days,
            hours,

            case
                when avg_wind_direction between 0 and 22.5
                then 'N'
                when avg_wind_direction between 22.5 and 67.5
                then 'NE'
                when avg_wind_direction between 67.5 and 112.5
                then 'E'
                when avg_wind_direction between 112.5 and 157.5
                then 'SE'
                when avg_wind_direction between 157.5 and 202.5
                then 'S'
                when avg_wind_direction between 202.5 and 247.5
                then 'SW'
                when avg_wind_direction between 247.5 and 292.5
                then 'W'
                when avg_wind_direction between 292.5 and 337.5
                then 'NW'
                when avg_wind_direction between 337.5 and 360
                then 'N'
            end as cardinal_direction,

            avg_wind_direction,
            speed_bin,
            avg_wind_speed

        from joined_filtered

        order by 1, 2, 3, 4, 5, 6
    )

select *
from cardinal_directions_hourly
