-- WITH MaxWindSpeed AS(
-- 	SELECT
-- 		CEIL(MAX(wind_speed)) AS max_speed -- This calculates the ceil max of the entire dataset
-- 	FROM
-- 		wind_sites.upd_wind_site
-- ),
-- BinnedSpeed AS (
-- 	SELECT 
-- 		EXTRACT(YEAR FROM date_time) AS year,
-- 		EXTRACT(MONTH FROM date_time) AS month,
-- 		wind_speed, 
-- 		width_bucket(
-- 			CAST(wind_speed AS double precision),
-- 			0,
-- 			CAST((SELECT max_speed FROM MaxWindSpeed) AS double precision), -- this is the max speed of entire dataset
-- 			CAST((SELECT max_speed FROM MaxWindSpeed) AS integer) -- must be an int. We can cast it explicitly
-- 		) AS speed_bin
-- 	FROM 
-- 		wind_sites.upd_wind_site
-- )
-- SELECT
-- 	year,
-- 	month,
-- 	speed_bin,
-- 	COUNT(*) AS frequency
-- FROM
-- 	BinnedSpeed
-- GROUP BY 
-- 	year,
-- 	month,
-- 	speed_bin -- group by speed_bin with count means that those with 0 count arent shown
-- ;

CREATE OR REPLACE VIEW wind_sites.frequency_distribution AS
WITH MaxWindSpeed AS(
	SELECT
		CEIL(MAX(wind_speed)) AS max_speed -- This calculates the ceil max of the entire dataset
	FROM
		wind_sites.upd_wind_site
),
BinnedSpeed AS (
	SELECT 
		EXTRACT(YEAR FROM date_time) AS year,
		EXTRACT(MONTH FROM date_time) AS month,
		wind_speed, 
		width_bucket(
			CAST(wind_speed AS double precision),
			0,
			CAST((SELECT max_speed FROM MaxWindSpeed) AS double precision), -- this is the max speed of entire dataset
			CAST((SELECT max_speed FROM MaxWindSpeed) AS integer) -- must be an int. We can cast it explicitly
		) AS speed_bin
	FROM 
		wind_sites.upd_wind_site
), MonthlyCounts AS (
    SELECT
        year,
        month,
        speed_bin,
        COUNT(*) AS frequency,
        SUM(COUNT(*)) OVER (PARTITION BY year,month) AS monthly_total
    FROM
        BinnedSpeed
    GROUP BY 
        year,
        month,
        speed_bin -- group by speed_bin with count means that those with 0 count arent shown
)
SELECT
    year,
    month,
    speed_bin,
    frequency,
    ROUND((frequency / monthly_total) * 100,2) as percent_frequency
FROM 
    MonthlyCounts
ORDER BY
    year,
    month,
    speed_bin
;