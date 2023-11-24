WITH diurnal_variation_daily AS (
    SELECT
        year,
        month,
        year_month,
        hour,
        avg_wind_speed

    FROM {{ ref('diurnal_variation_daily') }}
),

monthly_aggregate AS (
    SELECT
        year,
        month,
        year_month,
        hour,
        ROUND(AVG(avg_wind_speed),3) AS avg_wind_speed

    FROM diurnal_variation_daily

    GROUP BY 1,2,3,4
)

SELECT * FROM monthly_aggregate

ORDER BY year, month, hour
