WITH feature_wind AS (
    SELECT * FROM {{ ref("feature_wind_hourly") }}
)

SELECT 
    years,
    months,
    year_month,
    days,
    hours,
    ROUND(avg_wind_speed,3)
FROM feature_wind

ORDER BY 1, 2, 3, 4, 5