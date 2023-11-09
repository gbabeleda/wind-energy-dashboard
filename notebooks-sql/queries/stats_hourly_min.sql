CREATE OR REPLACE VIEW wind_sites.stats_hourly_min AS
WITH MonthlyStats AS (
	SELECT  
		TO_CHAR(date_time, 'YYYY-FMMonth') AS year_month,
		MAX(wind_speed) AS monthly_max_speed,
		MIN(wind_speed) AS monthly_min_speed,
		ROUND(AVG(wind_speed),3) AS monthly_avg_speed
	FROM 	
			wind_sites.upd_wind_site
	GROUP BY
			TO_CHAR(date_time, 'YYYY-FMMonth')
	ORDER BY
				year_month
),
HourlyStats AS (
	SELECT  
		TO_CHAR(date_time, 'YYYY-FMMonth') AS year_month,
		EXTRACT(DAY FROM date_time) AS day,
		EXTRACT(HOUR FROM date_time) AS hour,
		wind_speed
	FROM 	
			wind_sites.upd_wind_site
)
SELECT 
	hs.year_month,
	hs.day,
	hs.hour,
	hs.wind_speed
FROM 
	MonthlyStats AS ms
JOIN
	HourlyStats AS hs
ON
	ms.year_month = hs.year_month
WHERE 
	wind_speed = monthly_min_speed