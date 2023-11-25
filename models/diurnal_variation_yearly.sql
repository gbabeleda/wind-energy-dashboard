WITH feature_wind AS (
    SELECT * FROM {{ ref('feature_wind') }}
)

SELECT 
    years,
    hours,
    
    ROUND(AVG(wind_speed),3) AS avg_wind_speed

FROM feature_wind

GROUP BY 1, 2

ORDER BY 1, 2