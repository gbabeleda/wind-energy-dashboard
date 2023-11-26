WITH feature_wind AS (
    SELECT * FROM {{ ref('feature_wind') }}
)

SELECT 
    years,
    months,
    year_month,
    
    MAX(wind_speed) AS max_speed,
    MIN(wind_speed) AS min_speed,
    ROUND(AVG(wind_speed),3) AS avg_speed

FROM feature_wind

GROUP BY 1,2,3
ORDER BY 1,2,3