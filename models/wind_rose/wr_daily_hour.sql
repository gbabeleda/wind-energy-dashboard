WITH cardinal_directions_hourly AS (
    SELECT * FROM {{ ref('cardinal_directions_hourly') }}
),

frequency AS (
    SELECT
        years,
        months,
        year_month,
        days,
        cardinal_direction,
        speed_bin,

        COUNT(*) AS count_freq

    FROM cardinal_directions_hourly

    GROUP BY 1,2,3,4,5,6
),

total_frequency AS (
    SELECT
        years,
        months,
        year_month,
        days,

        COUNT(*) AS count_total
    
    FROM cardinal_directions_hourly

    GROUP BY 1,2,3,4
),

percent_frequency AS (
    SELECT
        years,
        months,
        year_month,
        days,
        cardinal_direction,
        speed_bin,
        count_freq,
        count_total,

        CASE 
            WHEN count_total > 0 THEN ROUND((count_freq * 100) / count_total,3)
        ELSE 0
        END AS perc_freq
    
    FROM frequency

    JOIN total_frequency

    USING(years,months,year_month,days)
),

cumulative_frequency AS (
    SELECT 
        years,
        months,
        year_month,
        days,
        cardinal_direction,
        speed_bin,
        count_freq,
        count_total,
        perc_freq,

        ROUND(SUM(perc_freq) OVER (
            PARTITION BY years,months,year_month,days,cardinal_direction
            ORDER BY speed_bin
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),3) AS cumulative_perc_freq
    
    FROM percent_frequency
)

SELECT * FROM cumulative_frequency

ORDER BY 1,2,3,4,5,6