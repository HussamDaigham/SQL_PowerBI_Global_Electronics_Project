SELECT
    (SELECT COUNT(*) FROM core.sales) AS core_sales_lines,
    COUNT(*) AS reporting_sales_lines,
    COUNT(DISTINCT order_number) AS orders,
    SUM(quantity) AS units,
    SUM(estimated_revenue_usd) AS estimated_revenue_usd,
    SUM(estimated_cogs_usd) AS estimated_cogs_usd,
    SUM(estimated_gross_profit_usd) AS estimated_gross_profit_usd
FROM
    reporting.sales_line;