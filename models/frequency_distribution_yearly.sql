WITH binned_speed AS (
    SELECT * FROM {{ ref("binned_speed") }}
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
