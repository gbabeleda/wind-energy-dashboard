-- Rename columns
WITH source_data AS (
    SELECT 
        datetime AS date_time,
        windspeed AS wind_speed,
        gustspeed AS gust_speed,
        winddirection AS wind_direction
    FROM {{source("wind_energy_raw", "upd_wind")}}
    ORDER BY date_time
),
-- Remove rows with null values
cleaned_data AS (
    SELECT *
    FROM source_data
    WHERE wind_speed IS NOT NULL AND gust_speed IS NOT NULL AND wind_direction IS NOT NULL
)
SELECT 
    *
FROM cleaned_data
