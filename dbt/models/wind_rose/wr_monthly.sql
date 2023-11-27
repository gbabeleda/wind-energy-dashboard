with
    cardinal_directions as (select * from {{ ref("cardinal_directions") }}),

    frequency as (
        select
            years,
            months,
            year_month,
            cardinal_direction,
            speed_bin,

            count(*) as count_freq

        from cardinal_directions

        group by 1, 2, 3, 4, 5
    ),

    total_frequency as (
        select years, months, year_month, count(*) as count_total

        from cardinal_directions

        group by 1, 2, 3
    ),

    percent_frequency as (
        select
            years,
            months,
            year_month,
            cardinal_direction,
            speed_bin,
            count_freq,
            count_total,

            case
                when count_total > 0
                then round((count_freq * 100) / count_total, 3)
                else 0
            end as perc_freq

        from frequency

        join total_frequency using (years, months, year_month)
    ),

    cumulative_frequency as (
        select
            years,
            months,
            year_month,
            cardinal_direction,
            speed_bin,
            count_freq,
            count_total,
            perc_freq,
            round(
                sum(perc_freq) over (
                    partition by years, months, year_month, cardinal_direction
                    order by speed_bin
                    rows between unbounded preceding and current row
                ),
                3
            ) as cumulative_perc_freq

        from percent_frequency

        order by 1, 2, 3, 4, 5
    )

select *
from cumulative_frequency
