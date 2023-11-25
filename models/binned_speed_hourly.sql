WITH feature_wind_hourly AS (
    SELECT * FROM {{ ref("feature_wind_hourly") }}
),

max_wind_speed_hourly AS (
    SELECT CEIL(MAX(avg_wind_speed)) AS max_speed

    FROM feature_wind_hourly
),

binned_speed_hourly AS (
    SELECT  
        fwh.years,
        fwh.months,
        fwh.year_month,
        fwh.days,
        fwh.hours,

        CAST(
            CASE
                WHEN CEIL(fwh.avg_wind_speed / mwsh.max_speed * (mwsh.max_speed - 1)) = 0 THEN 1
                ELSE CEIL(fwh.avg_wind_speed / mwsh.max_speed * (mwsh.max_speed))
            END
            AS INT64 
            ) AS speed_bin,

        fwh.avg_wind_speed

    FROM feature_wind_hourly AS fwh
    CROSS JOIN max_wind_speed_hourly AS mwsh
)

SELECT * FROM binned_speed_hourly

ORDER BY 1,2,3,4,5