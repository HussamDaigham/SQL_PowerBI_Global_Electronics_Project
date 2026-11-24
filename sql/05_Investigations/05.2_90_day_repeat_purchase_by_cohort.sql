/*
Investigation: 90-Day Repeat Purchase Rate by Customer Cohort

Performance optimization:
A composite index on core.sales(customer_key, order_date)
was created to optimize the correlated EXISTS lookup.

Before index: 42,116.773 ms
After index:      65.703 ms
Improvement: approximately 641x faster

See: 05_create_performance_index.sql
*/

WITH customer_first_order AS(
    SELECT
        customer_key,
        MIN(order_date) AS first_purchase
    FROM
        reporting.order_summary
    GROUP BY
        customer_key
),

eligible_customers AS(
    SELECT
        customer_key,
        first_purchase,
        DATE_TRUNC('month', first_purchase)::DATE AS cohort_month,
        EXISTS(
            SELECT 1
            FROM core.sales AS s
            WHERE
                s.customer_key = c.customer_key AND
                s.order_date > c.first_purchase AND
                s.order_date <= (c.first_purchase + INTERVAL '90 days')
        ) AS returned_within_90_days_check
    FROM
        customer_first_order AS c
    WHERE
        (c.first_purchase + INTERVAL '90 days') <= (SELECT MAX(order_date) FROM reporting.order_summary)
)

SELECT
    cohort_month,
    COUNT(*) AS eligible_customer_count,
    COUNT(*) FILTER(WHERE(returned_within_90_days_check = TRUE)) AS returned_within_90_days_count,
    ROUND(
        (COUNT(*) FILTER(WHERE(returned_within_90_days_check = TRUE))::NUMERIC
        / NULLIF(COUNT(*) ,0)), 4) AS returned_within_90_days_rate
FROM
    eligible_customers
GROUP BY
    cohort_month
ORDER BY
    cohort_month;