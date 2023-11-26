with
    feature_wind_hourly as (select * from {{ ref("feature_wind_hourly") }}),

    diurnal_yearly as (
        
        select 
            years, 
            hours, 
        
            round(avg(avg_wind_speed), 3) as avg_wind_speed

        from feature_wind_hourly

        group by 1, 2

        order by 1, 2
    )

select *
from diurnal_yearly
