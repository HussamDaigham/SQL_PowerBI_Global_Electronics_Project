WITH customer_orders AS(
    SELECT
        customer_key,
        order_number,
        order_date,
        estimated_revenue_usd,
        ROW_NUMBER() OVER(
            PARTITION BY customer_key
            ORDER BY order_date, order_number
        ) AS customer_order_number
    FROM
        reporting.order_summary
),

first_second_order_revenues AS(
    SELECT
        customer_key,
        MAX(estimated_revenue_usd) FILTER(WHERE customer_order_number = 1) AS first_order_revenue_usd,
        MAX(estimated_revenue_usd) FILTER(WHERE customer_order_number = 2) AS second_order_revenue_usd
    FROM
        customer_orders
    WHERE
        customer_order_number IN (1,2)
    GROUP BY
        customer_key
    HAVING
        COUNT(estimated_revenue_usd) = 2
)

SELECT
    AVG(first_order_revenue_usd) AS avg_first_order_revenue_usd,
    AVG(second_order_revenue_usd) AS avg_second_order_revenue_usd,
    COUNT(*) AS repeat_customer_count,
    ROUND(
        COUNT(*) FILTER(WHERE second_order_revenue_usd > first_order_revenue_usd)::NUMERIC
        / NULLIF(COUNT(*),0),4) AS share_customers_with_larger_second_order
FROM
    first_second_order_revenues
;