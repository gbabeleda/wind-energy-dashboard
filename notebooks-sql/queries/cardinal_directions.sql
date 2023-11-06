WITH MaxWindSpeed AS (
	SELECT
		CEIL(MAX(wind_speed)) AS max_speed
	FROM
		wind_sites.upd_wind_site
), BinnedSpeed AS (
	SELECT 
		EXTRACT(YEAR FROM date_time) AS year,
		EXTRACT(MONTH FROM date_time) AS month,
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
), CardinalDirections AS (
	SELECT
		year,
		month,
		day, 
		wind_speed, 
		wind_direction,
		CASE 
			WHEN wind_direction >= 337.5 OR wind_direction < 22.5 THEN 'N'
			WHEN wind_direction >= 22.5 AND wind_direction < 67.5 THEN 'NE'
			WHEN wind_direction >= 67.5 AND wind_direction < 112.5 THEN 'E'
			WHEN wind_direction >= 112.5 AND wind_direction < 157.5 THEN 'SE'
			WHEN wind_direction >= 157.5 AND wind_direction < 202.5 THEN 'S'
			WHEN wind_direction >= 202.5 AND wind_direction < 247.5 THEN 'SW'
			WHEN wind_direction >= 247.5 AND wind_direction < 292.5 THEN 'W'
			WHEN wind_direction >= 292.5 AND wind_direction < 337.5 THEN 'NW'
			ELSE 'N'
		END AS cardinal_direction,
		speed_bin
	FROM 
		BinnedSpeed
)
SELECT
	year,
	month, 
	day,
	cardinal_direction,
	speed_bin,
	COUNT(*) AS frequency
FROM 
	CardinalDirections
GROUP BY
	year,
	month,
	day,
	cardinal_direction,
	speed_bin
;