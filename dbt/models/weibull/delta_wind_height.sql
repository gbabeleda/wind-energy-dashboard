with 
    monthly_stats as (select * from {{ ref('monthly_stats') }}),

    delta_wind_height as (
        select
            years,
            months,
            year_month,
            avg_speed,

            round((avg_speed * power((109 / 86), 0.34)),4) as wind_shear

        from monthly_stats

        order by 1,2,3
    )

select * from delta_wind_height


