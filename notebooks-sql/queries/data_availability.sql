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

-- CREATE OR REPLACE VIEW wind_sites.data_availability AS
-- SELECT 
--     a.year,
--     a.month,
--     COUNT(DISTINCT a.day)
-- FROM 
--     (
--         SELECT
--             EXTRACT(YEAR FROM date_time) AS year,
--             EXTRACT(MONTH FROM date_time) AS month,
--             EXTRACT(DAY FROM date_time) AS day
--         FROM
--             wind_sites.upd_wind_site AS upd
--     ) AS a
-- GROUP BY year, month
-- ;

-- DROP VIEW wind_sites.data_availability;