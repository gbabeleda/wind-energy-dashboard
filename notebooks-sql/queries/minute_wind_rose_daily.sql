CREATE OR REPLACE VIEW wind_sites.minute_wind_rose_daily
WITH MaxWindSpeed AS ( 
	SELECT
		CEIL(MAX(wind_speed)) AS max_speed
	FROM
		wind_sites.upd_wind_site
), 
BinnedSpeed AS ( 
	SELECT 
		EXTRACT(YEAR FROM date_time) AS year,
		EXTRACT(MONTH FROM date_time) AS month,
		TO_CHAR(date_time, 'YYYY-FMMonth') as year_month,
		EXTRACT(DAY FROM date_time) AS day,
		wind_speed,
		wind_direction,
		width_bucket( 
			wind_speed,
			0,
			CAST((SELECT max_speed FROM MaxWindSpeed) AS integer), 
			CAST((SELECT max_speed FROM MaxWindSpeed)AS integer) 
		) AS speed_bin 
	FROM 
		wind_sites.upd_wind_site
), 
-- assigns a wind_direction to a cardinal_direction
-- We do not want to consider those records with wind_speed = 0 
CardinalDirections AS ( 
	SELECT
		year,
		month,
		year_month,
		day, 
		wind_speed, 
		wind_direction,
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
		speed_bin 
	FROM 
		BinnedSpeed
	WHERE wind_speed > 0 
), 
-- Counts the number of wind records that fall into
-- year, month, year_month, day, cardinal_direction, speed_bin
Frequency AS (
	SELECT	
		year,
		month,
		year_month,
		day,
		cardinal_direction,
		speed_bin,
		COUNT(*) AS count_speed_bin
		
	FROM	
		CardinalDirections
	GROUP BY
		year,
		month,
		year_month,
		day,
		cardinal_direction,
		speed_bin
), 
-- Counts number of wind records that fall into year, month, year_month,
-- day, cardinal_direction. Ignores speed_bin. 
-- So all wind records per direction
TotalCounts AS ( 
	SELECT	
		year,
		month,
		year_month,
		day,
		COUNT(*) AS count_total
	FROM 
		CardinalDirections
	GROUP BY 
		year,
		month,
		year_month,
		day
), 
-- Percent Frequency of count_speed_bin / count_total per direction,
-- day, and month
PercentFrequency AS ( 
	SELECT	
		f.year,
		f.month,
		f.year_month,
		f.day,
		f.cardinal_direction,
		f.speed_bin,
		f.count_speed_bin, 
		tc.count_total,
		-- above converted to percentage
		ROUND((f.count_speed_bin * 100.0) / tc.count_total,3)  AS percent_frequency
	FROM 
		Frequency AS f
	JOIN 
		TotalCounts AS tc
	ON
		f.year = tc.year AND
		f.month = tc.month AND
		f.year_month = tc.year_month AND
		f.day = tc.day
	ORDER BY
		year,
		month,
		year_month,
		day,
		f.cardinal_direction,
		speed_bin
),
CumulativeFrequency AS (
	SELECT	
		pf.year,
		pf.month,
		pf.year_month,
        pf.day,
		pf.cardinal_direction,
		pf.speed_bin,
		pf.count_speed_bin,
		pf.count_total,
		pf.percent_frequency,
		SUM(pf.percent_frequency) OVER ( 
			PARTITION BY pf.year, pf.month, pf.year_month, pf.day, pf.cardinal_direction 
			ORDER BY pf.speed_bin
			ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
		) AS cumulative_percent_frequency
	FROM
		PercentFrequency AS pf
)
SELECT
	year,
	month,
	year_month,
	day,
	cardinal_direction,
	speed_bin,
	count_speed_bin,
	count_total,
	percent_frequency,
	cumulative_percent_frequency
FROM 
	CumulativeFrequency
;