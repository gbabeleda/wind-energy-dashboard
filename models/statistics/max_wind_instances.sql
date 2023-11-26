with 
    feature_wind as (
        select * from {{ ref('feature_wind') }}
    ),

    monthly_stats as ( 
        select * from {{ ref('monthly_stats') }}
    ),

    max_wind_instances as (
        select  
            feature_wind.year_month,
            days,
            hours,
            max_speed,

        from monthly_stats
        
        join feature_wind using (years,months)

        where max_speed = wind_speed
    )

select *
from max_wind_instances

    