with
    binned_speed as (select * from {{ ref("binned_speed") }}),

    yearly_counts as (
        
        select
            years,
            speed_bin,

            count(*) as frequency,

            sum(count(*)) over (partition by years) as yearly_total

        from binned_speed

        group by 1, 2
    ),

    frequency_distribution_yearly as (
        
        select
            years,
            speed_bin,
            frequency,
            
            round((frequency / yearly_total) * 100, 3) as percent_frequency

        from yearly_counts
        
        order by 1, 2
    )

select *
from frequency_distribution_yearly


