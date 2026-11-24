CREATE OR REPLACE VIEW reporting.p90_delivery_days AS
WITH online_orders AS(
    SELECT
    order_number,
    delivery_date,
    order_date,
    o.customer_key,
    delivery_date - order_date AS delivery_days,
    country
FROM
    reporting.order_summary AS o
JOIN core.customers AS c ON o.customer_key = c.customer_key
WHERE
    store_key = 0 AND
    delivery_date IS NOT NULL
)

SELECT
    country,
    MIN(delivery_days) AS min_delivery_days,
    MAX(delivery_days) AS max_delivery_days,
    COUNT(*) AS delivered_online_order_count,
    ROUND(PERCENTILE_CONT(0.90)
        WITHIN GROUP (
            ORDER BY delivery_days)::NUMERIC, 2) AS p90_delivery_days
FROM
    online_orders
GROUP BY
    COUNTRY
ORDER BY
    country;