with
    binned_speed as (select * from {{ ref("binned_speed") }}),

    monthly_counts as (

        select
            years,
            months,
            year_month,
            speed_bin,

            count(*) as frequency,

            sum(count(*)) over (partition by years, months) as monthly_total

        from binned_speed

        group by 1, 2, 3, 4
    ),

    frequency_distribution_monthly as (

        select
            years,
            months,
            year_month,
            speed_bin,
            frequency,
            round((frequency / monthly_total) * 100, 3) as percent_frequency

        from monthly_counts

        order by 1, 2, 3, 4
    )

select *
from frequency_distribution_monthly
