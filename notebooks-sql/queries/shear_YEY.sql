CREATE OR REPLACE VIEW wind_sites.wind_shear_yey AS 
WITH MonthlyAverages AS (
    SELECT
        EXTRACT(MONTH FROM date_time) AS month,
		TO_CHAR(date_time, 'YYYY-FMMonth') AS year_month,
        ROUND(AVG(wind_speed), 4) AS avg_wind_speed
    FROM
        wind_sites.upd_wind_site
    GROUP BY 1,2
),
WindShear AS (
    SELECT
        month,
		year_month,
        avg_wind_speed,
        ROUND(avg_wind_speed * POWER(CAST(111 AS NUMERIC) / 86, 0.34), 4) AS wind_shear
    FROM 
        MonthlyAverages
    ORDER BY
        1 ASC, 2
),
TurbinePowerCurve AS (
	SELECT 
		ws.month,
		ws.year_month,
		ws.avg_wind_speed,
		ws.wind_shear,
		gs.num AS wind_turbine_speeds,
		CASE
			WHEN gs.num < 5 THEN 0
			WHEN gs.num = 5 THEN 5
			WHEN gs.num = 5.5 THEN 8
			WHEN gs.num = 6 THEN 13
			WHEN gs.num = 6.5 THEN 19
			WHEN gs.num = 7 THEN 26
			WHEN gs.num = 7.5 THEN 32
			WHEN gs.num = 8 THEN 39
			WHEN gs.num = 8.5 THEN 46
			WHEN gs.num = 9 THEN 53
			WHEN gs.num = 9.5 THEN 59
			WHEN gs.num = 10 THEN 65
			WHEN gs.num = 10.5 THEN 71
			WHEN gs.num = 11 THEN 76
			WHEN gs.num = 11.5 THEN 80
			WHEN gs.num = 12 THEN 84
			WHEN gs.num = 12.5 THEN 88
			WHEN gs.num = 13 THEN 92
			WHEN gs.num = 13.5 THEN 95
			WHEN gs.num = 14 THEN 97
			WHEN gs.num = 14.5 THEN 100
			WHEN gs.num = 15 THEN 102
			WHEN gs.num = 15.5 THEN 104
			WHEN gs.num = 16 THEN 105
			WHEN gs.num = 16.5 THEN 107
			WHEN gs.num = 17 THEN 108
			WHEN gs.num BETWEEN 17.5 AND 20.5 THEN 109
			WHEN gs.num BETWEEN 21 AND 21.5 THEN 108
			WHEN gs.num = 22 THEN 107
			WHEN gs.num = 22.5 THEN 106
			WHEN gs.num = 23 THEN 105
			WHEN gs.num = 23.5 THEN 104
			WHEN gs.num = 24 THEN 103
			WHEN gs.num BETWEEN 24.5 AND 25 THEN 102
		END AS power_curve
	FROM 
		WindShear AS ws
	JOIN generate_series(0, 25,0.5) AS gs(num) ON true
), Weibull AS (
	SELECT
		month,
		year_month,
		avg_wind_speed,
		wind_shear,
		wind_turbine_speeds,
		power_curve,
		CASE 	
			WHEN wind_shear > 0 THEN
				((PI() * wind_turbine_speeds) / (2 * POWER(wind_shear, 2))) * EXP((-PI()/4) * POWER((wind_turbine_speeds/wind_shear), 2))
			ELSE
				0
		END AS f_v
	FROM
		TurbinePowerCurve
)
SELECT
	month,
	year_month,
	avg_wind_speed,
	wind_shear,
	wind_turbine_speeds,
	power_curve,
	f_v,
	f_v * power_curve * 24 AS daily_yey,
	f_v * power_curve * 8760 AS yearly_yey
FROM
	Weibull
;


