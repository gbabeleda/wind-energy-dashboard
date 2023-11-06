COPY wind_sites.upd_wind_site (date_time,wind_speed,gust_speed,wind_direction)
FROM '/Users/gioabeleda/Desktop/wind-energy-dashboard-streamlit/data/wind_energy.csv'
DELIMITER ','
CSV HEADER;