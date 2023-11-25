{# Feature Engineering (?) #}
SELECT 
    EXTRACT(YEAR FROM date_time) AS years,
    EXTRACT(MONTH FROM date_time) AS months,
    FORMAT_TIMESTAMP('%Y-%B', date_time) as year_month,
    EXTRACT(DAY FROM date_time) AS days,
    EXTRACT(HOUR FROM date_time) + 1 AS hours,
    wind_speed,
    wind_direction
FROM {{ ref('stg_wind_raw') }}