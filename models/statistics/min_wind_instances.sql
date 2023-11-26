with 
    feature_wind as (
        select * from {{ ref('feature_wind') }}
    ),

    monthly_stats as ( 
        select * from {{ ref('monthly_stats') }}
    ),

    min_wind_instances as (
        select  
            feature_wind.year_month,
            days,
            hours,
            min_speed,

        from monthly_stats
        
        join feature_wind using (years,months)

        where min_speed = wind_speed
    )

select *
from min_wind_instances

    