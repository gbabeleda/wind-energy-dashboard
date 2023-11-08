CREATE OR REPLACE VIEW wind_sites.cumulative_frequency_cardinal_directions AS
WITH MaxWindSpeed AS ( -- determining max speed over the entire dataset to determine the maximum number of speed_bins
	SELECT
		CEIL(MAX(wind_speed)) AS max_speed
	FROM
		wind_sites.upd_wind_site
), BinnedSpeed AS ( -- assigns each wind_speed and wind_direction to a speed_bin for use later
	SELECT 
		EXTRACT(YEAR FROM date_time) AS year,
		EXTRACT(MONTH FROM date_time) AS month,
		EXTRACT(DAY FROM date_time) AS day,
		wind_speed,
		wind_direction,
		width_bucket( -- use of width bucket to create bins. Can also use CASE WHEN if ever
			wind_speed,
			0,
			CAST((SELECT max_speed FROM MaxWindSpeed) AS integer), -- use of subquery to assign max_speed
			CAST((SELECT max_speed FROM MaxWindSpeed)AS integer) -- use of subquery to assign max_speed
		) AS speed_bin -- each wind_speed is assigned a speed_bin
	FROM 
		wind_sites.upd_wind_site
), CardinalDirections AS ( -- assigns a wind_direction to a cardinal_direction
	SELECT
		year,
		month,
		day, 
		wind_speed, 
		wind_direction, -- included for sake of confirming if cardinal_direction is correct
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
		speed_bin -- called after wind_direction but not necessarily after at this point
	FROM 
		BinnedSpeed
	WHERE wind_speed > 0 -- We do not want to consider those records with wind_speed = 0 
), Frequency AS (
	SELECT	
		year,
		month,
		day,
		cardinal_direction,
		speed_bin,
		COUNT(*) OVER (PARTITION BY year, month, day, cardinal_direction,speed_bin) AS bin_count -- window function
		-- window function is a feature that performs calculations across a set of table rows that are somehow related
		-- COUNT(*) count all rows
		-- OVER signifiees COUNT should be applied over a window of rows defined by PARTITION BY
		-- PARTITION BY defines the window. The subset of rows over which the COUNT function will operate
		-- COUNT is set to all rows that have the same values for year, month, day, cardinal,direction, and speed_bin
		-- Essentially like a group by but for calculating a window function
		-- bin_count will tell you how many rows there are for each unique combination of these fields
	FROM	
		-- IMPORTANT
		-- THIS IS DONE TO AVOID ROW DUPLICATION FOR SOME REASON
		(SELECT DISTINCT year, month, day, cardinal_direction, speed_bin FROM CardinalDirections) AS unique_measurements
), TotalCounts AS ( 
	-- counts all the instances of a wind record in that particular wind_direction for a given year,month,day
	-- deliberately merges all speed_bins for comparison later
	SELECT	
		year,
		month,
		day,
		cardinal_direction,
		COUNT(*) AS total_count
	FROM 
		CardinalDirections
	GROUP BY 
		year,
		month,
		day,
		cardinal_direction
), PercentFrequency AS ( 
	SELECT	
		f.year,
		f.month,
		f.day,
		f.cardinal_direction,
		f.speed_bin,
		f.bin_count, -- frequency of wind records given the above comination
		ROUND(f.bin_count * 100.0) / tc.total_count AS percent_frequency
	FROM 
		Frequency AS f
	JOIN 
		TotalCounts AS tc
	ON
		f.year = tc.year AND
		f.month = tc.month AND
		f.day = tc.day AND
		f.cardinal_direction = tc.cardinal_direction
), CumulativeFrequency AS (
	-- this is the part where shit gets wild
	-- I have no idea how to compute cumulative anything in python even, much less SQL
	SELECT	
		pf.year,
		pf.month,
		pf.day,
		pf.cardinal_direction,
		pf.speed_bin,
		-- the following is a window function again
		SUM(pf.percent_frequency) OVER ( 
			PARTITION BY pf.year, pf.month, pf.day, pf.cardinal_direction 
			ORDER BY pf.speed_bin
			ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
		) AS cumulative_percent_frequency
		-- SUM(pf.percent_frequency) calculates the sum of percent_frequency column values
		-- OVER window function
		-- PARTION BY divides the result set into partitions to which SUM is applied
		-- Within each partition the sum is calculated independently
		-- ORDER BY speed_bin
	
	FROM
		PercentFrequency AS pf
)
SELECT 
	year,
	month,
	day,
	cardinal_direction,
	speed_bin,
	cumulative_percent_frequency
FROM
	CumulativeFrequency
;