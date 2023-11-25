WITH feature_wind AS (
    SELECT * FROM {{ ref("feature_wind") }}
),
data_availability AS (
    SELECT  
        years,
        months,
        year_month,
        COUNT(DISTINCT days) AS count_days
    
    FROM feature_wind

    GROUP BY 1,2,3
)

SELECT * FROM data_availability

ORDER BY 1,2,3