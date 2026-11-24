WITH year_channel_summary AS(
    SELECT
        EXTRACT(YEAR FROM order_date) AS order_year,
        CASE
            WHEN store_key = 0 THEN 'Online'
            ELSE 'Physical Store'
        END AS sales_channel,
        COUNT(DISTINCT order_number) AS order_count,
        SUM(estimated_revenue_usd) AS total_revenue,
        AVG(estimated_revenue_usd) AS average_order_value
    FROM
        reporting.order_summary
    WHERE
        EXTRACT(YEAR FROM order_date) <> 2021
    GROUP BY
        sales_channel,
        order_year
),

previous_year_summary_channel AS(
    SELECT
        order_year,
        sales_channel,
        total_revenue,
        LAG(total_revenue) OVER(
        PARTITION BY sales_channel
        ORDER BY order_year
        ) AS previous_year_revenue,
        order_count,
        LAG(order_count) OVER(
        PARTITION BY sales_channel
        ORDER BY order_year
        ) AS previous_year_order_count,
        average_order_value,
        LAG(average_order_value) OVER(
        PARTITION BY sales_channel
        ORDER BY order_year
    ) AS previous_year_average_order_value
    FROM
        year_channel_summary
)

SELECT
    order_year,
    sales_channel,
    order_count,
    previous_year_order_count,
    ROUND(
        (order_count - previous_year_order_count)::NUMERIC
        / NULLIF(previous_year_order_count, 0), 4) AS yoy_order_count_change_pct,
    average_order_value,
    previous_year_average_order_value,
    ROUND(
        (average_order_value - previous_year_average_order_value)::NUMERIC
        / NULLIF(previous_year_average_order_value, 0), 4) AS yoy_average_order_value_change_pct,
    total_revenue,
    (total_revenue - previous_year_revenue) AS yoy_revenue_change_usd
FROM
    previous_year_summary_channel
ORDER BY
    order_year,
    sales_channel;



/*
Physical Stores had the largest year-over-year revenue change in dollar terms, a $7.13 million decline from 2019 to 2020.
Orders fell from 7,077 to 3,564 (down 49.64%), while average order value fell from $2,028.53 to $2,027.13 (down 0.07%).
The decline was driven primarily by fewer orders.
*/
