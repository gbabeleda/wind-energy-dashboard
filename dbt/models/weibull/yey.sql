with 
    weibull as (select * from {{ ref('weibull') }}),

    yey as (
        select  
            years,
            months,
            year_month,
            f_v,
            power_curve,
            f_v * power_curve * 24 as daily_yey_per_month,
            f_v * power_curve * 8760 as yearly_yey_per_month

        from weibull
    ),

    sum_yey as (
        select
            years,
            months,
            year_month,
            round(sum(daily_yey_per_month),3) as sum_yey_daily,
            round(sum(yearly_yey_per_month),3) as sum_yey_yearly

        from yey

        group by 1,2,3

        order by 1,2,3
    )

select *
from sum_yey