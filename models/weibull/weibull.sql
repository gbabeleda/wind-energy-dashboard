with
    delta_wind_height as (select * from {{ ref("delta_wind_height") }}),

    turbine_power_curve as (
        select
            num as speed_at_turbine,
            case
                when num < 5
                then 0
                when num = 5
                then 5
                when num = 5.5
                then 8
                when num = 6
                then 13
                when num = 6.5
                then 19
                when num = 7
                then 26
                when num = 7.5
                then 32
                when num = 8
                then 39
                when num = 8.5
                then 46
                when num = 9
                then 53
                when num = 9.5
                then 59
                when num = 10
                then 65
                when num = 10.5
                then 71
                when num = 11
                then 76
                when num = 11.5
                then 80
                when num = 12
                then 84
                when num = 12.5
                then 88
                when num = 13
                then 92
                when num = 13.5
                then 95
                when num = 14
                then 97
                when num = 14.5
                then 100
                when num = 15
                then 102
                when num = 15.5
                then 104
                when num = 16
                then 105
                when num = 16.5
                then 107
                when num = 17
                then 108
                when num between 17.5 and 20.5
                then 109
                when num between 21 and 21.5
                then 108
                when num = 22
                then 107
                when num = 22.5
                then 106
                when num = 23
                then 105
                when num = 23.5
                then 104
                when num = 24
                then 103
                when num between 24.5 and 25
                then 102
            end as power_curve
        from (
            {# Sub-query to generate the array 0-25 in 0.5 increments #}
            {# generate_array creates the array with from min to max, with step-wise function #}
            {# unnest returns a table with #}
            select num 

            from unnest(generate_array(0,25,0.5)) as num
        )
    ),

    combined_data as (
        select
            years,
            months,
            year_month,
            wind_shear,
            speed_at_turbine,
            power_curve

        from delta_wind_height as dwh

        cross join turbine_power_curve

        order by 1,2,3,4,5
    ),

    weibull as (
        select
            years,
            months,
            year_month,
            wind_shear,
            speed_at_turbine,
            power_curve,

            case
                when wind_shear > 0 then
                    ((acos(-1) * speed_at_turbine) / (2 * power(wind_shear,2)) * exp((-acos(-1) / 4) * power(speed_at_turbine / wind_shear,2)))
                else 0
            end as f_v

        from combined_data

    )

select * from weibull