SELECT 
    years,
    hours,
    ROUND(AVG(wind_speed),3) AS avg_wind_speed

FROM {{ ref('feature_wind') }}

GROUP BY 1, 2

ORDER BY 1, 2