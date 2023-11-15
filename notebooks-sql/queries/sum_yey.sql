CREATE OR REPLACE VIEW wind_sites.sum_yey AS
SELECT 
	month,
	year_month, 
	wind_shear,
	ROUND(SUM(daily_yey::NUMERIC),4) AS YEY_day_in_month,
	ROUND(SUM(yearly_yey::NUMERIC),4) AS YEY_year
FROM
	wind_sites.wind_shear_yey
GROUP BY 
	month,
	year_month, 
	wind_shear