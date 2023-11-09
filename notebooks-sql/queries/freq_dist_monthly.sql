-- Test Results
-- The COUNT(*) of the original dataset and the SUM(frequency) are equivalent
-- MaxWindSpeed returns 12
-- Binned Speed
-- Seems like all the bins are correct
-- COUNT(*) is the same as original dataset
-- the monthly_total column seems correct and adds the count of all rows that have the same year, month

-- Learnings
-- Creating a view
-- Using a CTE via WITH cte AS () statement
-- Using the width_bucket() function
-- Using the extract() function
-- Using a window function. Study this more. 


-- Final and Correct mostly have some 99.99 stuff
CREATE OR REPLACE VIEW wind_sites.frequency_distribution_monthly AS
-- Identifies max speed in the dataset
WITH MaxWindSpeed AS(
	SELECT
		CEIL(MAX(wind_speed)) AS max_speed
	FROM
		wind_sites.upd_wind_site
),
-- Creates wind speed bins
-- First time using a width bucket to do data binning
-- The width bucket takes the following arguments with data types
-- (operand double precision, b1 double precision, b2 double precision, count integer)
BinnedSpeed AS (
	SELECT 
		EXTRACT(YEAR FROM date_time) AS year,
		EXTRACT(MONTH FROM date_time) AS month,
        TO_CHAR(date_time, 'YYYY-FMMonth') as year_month,
		wind_speed, 
		width_bucket(
			CAST(wind_speed AS double precision),
			0,
			CAST((SELECT max_speed FROM MaxWindSpeed) AS double precision), 
			CAST((SELECT max_speed FROM MaxWindSpeed) AS integer) 
		) AS speed_bin
	FROM 
		wind_sites.upd_wind_site
), 
-- First time using window functions
-- group by speed_bin with count means that those with 0 count arent shown
MonthlyCounts AS (
    SELECT
        year,
        month,
        year_month,
        speed_bin,
        COUNT(*) AS frequency,
        SUM(COUNT(*)) OVER (PARTITION BY year,month) AS monthly_total
    FROM
        BinnedSpeed
    GROUP BY 
        year,
        month,
        year_month,
        speed_bin 
)
-- Final Select
SELECT
    year,
    month,
    year_month,
    speed_bin,
    frequency,
    ROUND((frequency / monthly_total) * 100,3) as percent_frequency
FROM 
    MonthlyCounts
ORDER BY
    year,
    month,
    year_month,
    speed_bin
;