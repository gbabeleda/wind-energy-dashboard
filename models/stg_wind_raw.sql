WITH source_data AS (
    SELECT 
        _GMT_08_00_ AS date_time,
        Wind_Speed__m_s AS wind_speed,
        Gust_Speed__m_s AS gust_speed,
        Wind_Direction____ AS wind_direction
    FROM {{source("wind_energy_raw", "upd_wind")}}
)

SELECT 
    *
FROM source_data
-- WHERE wind_speed IS NOT NULL AND gust_speed IS NOT NULL AND wind_direction IS NOT 