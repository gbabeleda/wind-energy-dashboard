{# Rename columns #}
with
    source_data as (
        
        select
            datetime as date_time,
            windspeed as wind_speed,
            gustspeed as gust_speed,
            winddirection as wind_direction

        from {{ source("raw", "upd_wind") }}
    ),

    {# Remove rows will null values in selected columns #}
    cleaned_data as (
        
        select * from source_data

        where
            wind_speed is not null
            and gust_speed is not null
            and wind_direction is not null
    ),

    {# Cast data types as desired #}
    casted_data as (
        
        select
            parse_timestamp('%m/%d/%y %H:%M', date_time) as date_time,
            cast(wind_speed as float64) as wind_speed,
            cast(gust_speed as float64) as gust_speed,
            cast(wind_direction as float64) as wind_direction

        from cleaned_data
        order by 1
    )

select *
from casted_data


