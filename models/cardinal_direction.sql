WITH feature_wind AS (
    SELECT * FROM {{ ref("feature_wind") }}
),

binned_speed AS (
    SELECT * FROM {{ ref("binned_speed") }}
),
joined_filtered AS (
    SELECT 
        years,
        months,
        year_month,
        days,
        hours,
        
        bs.speed_bin,

        wind_speed,

        fw.wind_direction,

    FROM feature_wind AS fw

    JOIN binned_speed AS bs
    
    USING(years,months,year_month,days,hours,wind_speed)

    WHERE wind_speed > 0 
),
cardinal_directions AS (
    SELECT 
        years,
        months,
        year_month,
        days,
        hours,
        
        CASE 
            WHEN wind_direction BETWEEN 0 AND 22.5 THEN 'N'
			WHEN wind_direction BETWEEN 22.5 AND 67.5 THEN 'NE'
			WHEN wind_direction BETWEEN 67.5 AND 112.5 THEN 'E'
			WHEN wind_direction BETWEEN 112.5 AND 157.5 THEN 'SE'
			WHEN wind_direction BETWEEN 157.5 AND 202.5 THEN 'S'
			WHEN wind_direction BETWEEN 202.5 AND 247.5 THEN 'SW'
			WHEN wind_direction BETWEEN 247.5 AND 292.5 THEN 'W'
			WHEN wind_direction BETWEEN 292.5 AND 337.5 THEN 'NW'
			WHEN wind_direction BETWEEN 337.5 AND 360 THEN 'N'
		END AS cardinal_direction,

        wind_direction,
        speed_bin,
        wind_speed
    
    FROM joined_filtered 
)

SELECT * FROM cardinal_directions

ORDER BY 1,2,3,4,5,6
