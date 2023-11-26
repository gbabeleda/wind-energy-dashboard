with

feature_wind as (
    select * from {{ ref("feature_wind") }}
),

data_availability as (
    select 
        years, 
        months, 
        year_month, 
        count(distinct days) as count_days

    from feature_wind

    group by 1, 2, 3
)

select * from data_availability

order by 1, 2, 3
