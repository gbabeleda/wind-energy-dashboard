CREATE OR REPLACE VIEW wind_sites.minute_wind_rose_yearly AS
WITH MaxWindSpeed AS ( 
	SELECT
		CEIL(MAX(wind_speed)) AS max_speed
	FROM
		wind_sites.upd_wind_site
), 
BinnedSpeed AS ( 
	SELECT 
		EXTRACT(YEAR FROM date_time) AS year,
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
CardinalDirections AS ( 
	SELECT
		year,
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
Frequency AS (
	SELECT	
		year,
		cardinal_direction,
		speed_bin,
		COUNT(*) AS count_speed_bin
		
	FROM	
		CardinalDirections
	GROUP BY
		year,
		cardinal_direction,
		speed_bin
), 
TotalCounts AS ( 
	SELECT	
		year,
		cardinal_direction,
		COUNT(*) AS count_total
	FROM 
		CardinalDirections
	GROUP BY 
		year,
		cardinal_direction
), 
PercentFrequency AS ( 
	SELECT	
		f.year,
		f.cardinal_direction,
		f.speed_bin,
		f.count_speed_bin, 
		tc.count_total,
		ROUND(f.count_speed_bin * 100.0) / tc.count_total AS percent_frequency
	FROM 
		Frequency AS f
	JOIN 
		TotalCounts AS tc
	ON
		f.year = tc.year AND
		f.cardinal_direction = tc.cardinal_direction
	ORDER BY
		year,
		cardinal_direction,
		speed_bin
), 
CumulativeFrequency AS (
	SELECT	
		pf.year,
		pf.cardinal_direction,
		pf.speed_bin,
		pf.count_speed_bin,
		pf.count_total,
		SUM(pf.percent_frequency) OVER ( 
			PARTITION BY pf.year, pf.cardinal_direction 
			ORDER BY pf.speed_bin
			ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
		) AS cumulative_percent_frequency
	FROM
		PercentFrequency AS pf
)
SELECT 
	year,
	cardinal_direction,
	speed_bin,
	count_speed_bin,
	count_total,
	ROUND(cumulative_percent_frequency,3) as cumulative_percent
FROM
	CumulativeFrequency
ORDER BY
	year,
	cardinal_direction,
	speed_bin
;