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
        fw.wind_speed,

        CAST(
            CASE
                WHEN CEIL(fw.wind_speed / mws.max_speed * (mws.max_speed - 1)) = 0 THEN 1
                ELSE CEIL(fw.wind_speed / mws.max_speed * (mws.max_speed))
            END
            AS INT64
            ) AS speed_bin

    FROM feature_wind AS fw
    CROSS JOIN max_wind_speed AS mws
),

yearly_counts AS (
    SELECT  
        years,
        speed_bin,
        
        COUNT(*) AS frequency,

        SUM(COUNT(*)) OVER (PARTITION BY years) AS yearly_total

    FROM binned_speed
    
    GROUP BY 1,2
),

frequency_distribution_yearly AS (
    SELECT
        years,
        speed_bin,
        frequency,
        ROUND(( frequency / yearly_total ) * 100 ,3) AS percent_frequency

    FROM yearly_counts

)

SELECT * FROM frequency_distribution_yearly

ORDER BY 1,2
