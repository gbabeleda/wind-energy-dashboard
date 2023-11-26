WITH feature_wind_hourly AS (
    SELECT * FROM {{ ref('feature_wind_hourly') }}
)

SELECT 
    years,
    months,
    year_month,
    hours,
    
    ROUND(AVG(avg_wind_speed),3) AS avg_wind_speed

FROM feature_wind_hourly

GROUP BY 1, 2, 3, 4

ORDER BY 1, 2, 3, 4