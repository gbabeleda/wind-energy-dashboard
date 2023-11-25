WITH feature_wind_hourly AS (
    SELECT * FROM {{ ref("feature_wind_hourly") }}
)

SELECT 
    years,
    months,
    year_month,
    days,
    hours,
    ROUND(avg_wind_speed,3) AS avg_wind_speed
FROM feature_wind_hourly

ORDER BY 1, 2, 3, 4, 5