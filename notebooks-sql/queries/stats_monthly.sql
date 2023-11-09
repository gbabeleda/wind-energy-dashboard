CREATE OR REPLACE VIEW wind_sites.stats_monthly AS 
SELECT  
TO_CHAR(date_time, 'YYYY-FMMonth') AS year_month,
MAX(wind_speed) AS montly_max_speed,
MIN(wind_speed) AS monthly_min_speed,
ROUND(AVG(wind_speed),3) AS montly_avg_speed
FROM 
    wind_sites.upd_wind_site
GROUP BY
	TO_CHAR(date_time, 'YYYY-FMMonth')
ORDER BY
		year_month