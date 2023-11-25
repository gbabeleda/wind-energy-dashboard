WITH feature_wind_hourly AS (
    SELECT * FROM {{ ref("feature_wind_hourly") }}
),

binned_speed_hourly AS (
    SELECT * FROM {{ ref("binned_speed_hourly") }}
),
joined_filtered AS (
    SELECT 
        years,
        months,
        year_month,
        days,
        hours,
        
        bsh.speed_bin,

        avg_wind_speed,

        fwh.avg_wind_direction,

    FROM feature_wind_hourly AS fwh

    JOIN binned_speed_hourly AS bsh
    
    USING(years,months,year_month,days,hours,avg_wind_speed)

    WHERE avg_wind_speed > 0 
),
cardinal_directions_hourly AS (
    SELECT 
        years,
        months,
        year_month,
        days,
        hours,
        
        CASE 
            WHEN avg_wind_direction BETWEEN 0 AND 22.5 THEN 'N'
			WHEN avg_wind_direction BETWEEN 22.5 AND 67.5 THEN 'NE'
			WHEN avg_wind_direction BETWEEN 67.5 AND 112.5 THEN 'E'
			WHEN avg_wind_direction BETWEEN 112.5 AND 157.5 THEN 'SE'
			WHEN avg_wind_direction BETWEEN 157.5 AND 202.5 THEN 'S'
			WHEN avg_wind_direction BETWEEN 202.5 AND 247.5 THEN 'SW'
			WHEN avg_wind_direction BETWEEN 247.5 AND 292.5 THEN 'W'
			WHEN avg_wind_direction BETWEEN 292.5 AND 337.5 THEN 'NW'
			WHEN avg_wind_direction BETWEEN 337.5 AND 360 THEN 'N'
		END AS cardinal_direction,

        avg_wind_direction,
        speed_bin,
        avg_wind_speed
    
    FROM joined_filtered
)

SELECT * FROM cardinal_directions_hourly

ORDER BY 1,2,3,4,5,6