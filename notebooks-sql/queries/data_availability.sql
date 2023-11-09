-- Learnings
-- TO_CHAR is useful
-- You can count(distinct) the result set of EXTRACT(DAY FROM date_time) 
-- to count the number of unique days present in a year, month, year_month combo

-- Final 
CREATE OR REPLACE VIEW wind_sites.data_availability AS
SELECT 
    EXTRACT(YEAR FROM date_time) AS year,
    EXTRACT(MONTH FROM date_time) AS month,
	TO_CHAR(date_time, 'YYYY-FMMonth') as year_month,
    COUNT(DISTINCT EXTRACT(DAY FROM date_time)) as days_count
FROM 
    wind_sites.upd_wind_site
GROUP BY 1,2, TO_CHAR(date_time, 'YYYY-FMMonth')
;