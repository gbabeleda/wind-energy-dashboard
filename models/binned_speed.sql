WITH feature_wind AS (
    SELECT * FROM {{ ref("feature_wind") }}
),

max_wind_speed AS (
    SELECT CEIL(MAX(wind_speed)) AS max_speed

    FROM feature_wind
),

binned_speed AS (
    SELECT  
        fw.years,
        fw.months,
        fw.year_month,
        fw.days,
        fw.hours,

        CAST(
            CASE
                WHEN CEIL(fw.wind_speed / mws.max_speed * (mws.max_speed - 1)) = 0 THEN 1
                ELSE CEIL(fw.wind_speed / mws.max_speed * (mws.max_speed))
            END
            AS INT64 
            ) AS speed_bin,

        fw.wind_speed

    FROM feature_wind AS fw
    CROSS JOIN max_wind_speed AS mws
)

SELECT * FROM binned_speed

ORDER BY 1,2,3,4,5,6