WITH feature_wind_hourly AS (
    SELECT * FROM {{ ref('feature_wind_hourly') }}
), 

diurnal_variation_yearly AS (
    SELECT 
        years,
        hours,
        
        ROUND(AVG(avg_wind_speed),3) AS avg_wind_speed

    FROM feature_wind_hourly

    GROUP BY 1, 2
)

SELECT * FROM diurnal_variation_yearly

ORDER BY 1, 2