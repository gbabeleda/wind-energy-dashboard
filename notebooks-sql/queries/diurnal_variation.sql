-- Learnings



-- Final
CREATE OR REPLACE VIEW wind_sites.diurnal_variation AS
SELECT 
    EXTRACT(YEAR FROM date_time) AS year,
    EXTRACT(MONTH FROM date_time) AS month,
    TO_CHAR(date_time, 'YYYY-FMMonth') as year_month,
    EXTRACT(DAY FROM date_time) AS day,
    EXTRACT(HOUR FROM date_time) + 1 AS hour,
   ROUND(AVG(wind_speed),3) AS avg_wind_speed
FROM 
    wind_sites.upd_wind_site
GROUP BY 1, 2, TO_CHAR(date_time, 'YYYY-FMMonth'), 4,5
;