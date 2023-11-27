with 
    feature_wind as (select * from {{ ref("feature_wind") }}),

    monthly_stats as (
        select
            years,
            months,
            year_month,

            max(wind_speed) as max_speed,
            min(wind_speed) as min_speed,
            round(avg(wind_speed), 3) as avg_speed

        from feature_wind

        group by 1, 2, 3
        order by 1, 2, 3
    )

select * from monthly_stats

