{{ config(materialized='table') }}

{# Rename columns #}
WITH source_data AS (
    SELECT 
        datetime AS date_time,
        windspeed AS wind_speed,
        gustspeed AS gust_speed,
        winddirection AS wind_direction

    FROM {{ source("raw", "upd_wind") }}
),

{# Remove rows will null values in selected columns #}
cleaned_data AS (
    SELECT * FROM source_data

    WHERE wind_speed IS NOT NULL AND gust_speed IS NOT NULL AND wind_direction IS NOT NULL
),

{# Cast data types as desired #}
casted_data AS (
    SELECT  
        PARSE_TIMESTAMP('%m/%d/%y %H:%M', date_time) AS date_time,
        CAST(wind_speed AS FLOAT64) AS wind_speed,
        CAST(gust_speed AS FLOAT64) AS gust_speed,
        CAST(wind_direction AS FLOAT64) AS wind_direction 
    
    FROM cleaned_data
)

SELECT * FROM casted_data

ORDER BY 1
