with
    feature_wind as (select * from {{ ref("feature_wind") }}),

    binned_speed as (select * from {{ ref("binned_speed") }}),

    joined_filtered as (
        select
            years,
            months,
            year_month,
            days,
            hours,

            bs.speed_bin,

            wind_speed,

            fw.wind_direction,

        from feature_wind as fw

        join
            binned_speed as bs using (
                years, months, year_month, days, hours, wind_speed
            )

        where wind_speed > 0
    ),

    cardinal_directions as (
        select
            years,
            months,
            year_month,
            days,
            hours,

            case
                when wind_direction between 0 and 22.5
                then 'N'
                when wind_direction between 22.5 and 67.5
                then 'NE'
                when wind_direction between 67.5 and 112.5
                then 'E'
                when wind_direction between 112.5 and 157.5
                then 'SE'
                when wind_direction between 157.5 and 202.5
                then 'S'
                when wind_direction between 202.5 and 247.5
                then 'SW'
                when wind_direction between 247.5 and 292.5
                then 'W'
                when wind_direction between 292.5 and 337.5
                then 'NW'
                when wind_direction between 337.5 and 360
                then 'N'
            end as cardinal_direction,

            wind_direction,
            speed_bin,
            wind_speed

        from joined_filtered

        order by 1, 2, 3, 4, 5, 6
    )

select *
from cardinal_directions


