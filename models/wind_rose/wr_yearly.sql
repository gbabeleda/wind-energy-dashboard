with
    cardinal_directions as (select * from {{ ref("cardinal_directions") }}),

    frequency as (
        select years, cardinal_direction, speed_bin, count(*) as count_freq

        from cardinal_directions

        group by 1, 2, 3
    ),

    total_frequency as (
        select years, count(*) as count_total from cardinal_directions group by 1
    ),

    percent_frequency as (
        select
            years,
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

        join total_frequency using (years)
    ),

    cumulative_frequency as (
        select
            years,
            cardinal_direction,
            speed_bin,
            count_freq,
            count_total,
            perc_freq,
            round(
                sum(perc_freq) over (
                    partition by years, cardinal_direction
                    order by speed_bin
                    rows between unbounded preceding and current row
                ),
                3
            ) as cumulative_perc_freq

        from percent_frequency

        order by 1, 2, 3
    )

select *
from cumulative_frequency


