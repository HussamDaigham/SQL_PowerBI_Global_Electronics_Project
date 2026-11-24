SELECT
    (SELECT COUNT(*) FROM raw.sales) AS raw_rows,
    COUNT(*) AS core_rows,
    COUNT(DISTINCT order_number) AS orders,
    SUM(quantity) AS units,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    COUNT(*) FILTER (
        WHERE store_key = 0 AND delivery_date IS NULL
    ) AS online_lines_without_delivery_date,
    COUNT(*) FILTER (
        WHERE store_key <> 0 AND delivery_date IS NOT NULL
    ) AS physical_lines_with_delivery_date
FROM core.sales;


SELECT
    order_number
FROM
    core.sales
GROUP BY
    order_number
HAVING
    COUNT(DISTINCT(customer_key, store_key, order_date, delivery_date, currency_code)) > 1;