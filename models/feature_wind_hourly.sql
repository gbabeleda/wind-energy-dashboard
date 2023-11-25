{{ config(materialized='table') }}

WITH feature_wind AS (
    SELECT * FROM {{ ref("feature_wind") }}
),

feature_wind_hourly AS (
    SELECT 
        years,
        months,
        year_month,
        days,
        hours,

        ROUND(AVG(wind_speed),4) AS avg_wind_speed,
        ROUND(AVG(wind_direction),4) AS avg_wind_direction
    
    FROM feature_wind
    
    GROUP BY 1,2,3,4,5
)

SELECT * FROM feature_wind_hourly

ORDER BY 1,2,3,4,5