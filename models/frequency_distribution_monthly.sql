WITH binned_speed AS (
    SELECT * FROM {{ ref("binned_speed") }}
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
