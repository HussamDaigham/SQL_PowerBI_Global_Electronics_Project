SELECT
    COUNT(*) AS order_rows,
    COUNT(*) - COUNT(DISTINCT order_number) AS extra_rows_per_order,
    SUM(line_count) AS sales_lines,
    SUM(units) AS units,
    COUNT(*) FILTER (WHERE store_key = 0) AS online_orders,
    MIN(delivery_days) AS min_delivery_days,
    MAX(delivery_days) AS max_delivery_days,
    SUM(estimated_revenue_usd) AS estimated_revenue_usd,
    SUM(estimated_cogs_usd) AS estimated_cogs_usd,
    SUM(estimated_gross_profit_usd) AS estimated_gross_profit_usd
FROM
    reporting.order_summary;