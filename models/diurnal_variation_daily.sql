SELECT 
    years,
    months,
    year_month,
    days,
    hours,
    
    ROUND(AVG(wind_speed)) AS avg_wind_speed

FROM {{ ref('feature_wind') }}

GROUP BY 1, 2, 3, 4, 5

ORDER BY 1, 2, 3, 4, 5