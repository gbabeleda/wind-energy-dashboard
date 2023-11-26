with
    feature_wind as (select * from {{ ref("feature_wind") }}),

    max_wind_speed as (select ceil(max(wind_speed)) as max_speed from feature_wind),

    binned_speed as (
        select
            fw.years,
            fw.months,
            fw.year_month,
            fw.days,
            fw.hours,

            cast(
                case
                    when ceil(fw.wind_speed / mws.max_speed * (mws.max_speed - 1)) = 0
                    then 1
                    else ceil(fw.wind_speed / mws.max_speed * (mws.max_speed))
                end as int64
            ) as speed_bin,

            fw.wind_speed

        from feature_wind as fw
        cross join max_wind_speed as mws

        order by 1, 2, 3, 4, 5, 6
    )

select *
from binned_speed


