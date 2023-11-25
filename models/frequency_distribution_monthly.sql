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
        fw.wind_speed,

        CAST(
          CEIL(fw.wind_speed / mws.max_speed * mws.max_speed) 
          AS INT64
        ) AS speed_bin

    FROM feature_wind AS fw
    CROSS JOIN max_wind_speed AS mws
),

monthly_counts AS (
    SELECT  
        years,
        months,
        year_month,
        speed_bin,
        
        COUNT(*) AS frequency,

        SUM(COUNT(*)) OVER (PARTITION BY years,months) AS monthly_total

    FROM binned_speed
    
    GROUP BY 1,2,3,4
),

frequency_distribution_monthly AS (
    SELECT
        years,
        months,
        year_month,
        speed_bin,
        frequency,
        ROUND(( frequency / monthly_total ) * 100 ,3) AS percent_frequency

    FROM monthly_counts

)

SELECT * FROM frequency_distribution_monthly

ORDER BY 1,2,3,4
