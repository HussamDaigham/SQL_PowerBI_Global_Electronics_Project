CREATE OR REPLACE VIEW reporting.order_summary AS
SELECT
    order_number,
    customer_key,
    store_key,
    order_date,
    delivery_date,
    currency_code,
    COUNT(*) AS line_count,
    SUM(quantity) AS units,
    SUM(estimated_revenue_usd) AS estimated_revenue_usd,
    SUM(estimated_cogs_usd) AS estimated_cogs_usd,
    SUM(estimated_gross_profit_usd) AS estimated_gross_profit_usd,
    delivery_date - order_date AS delivery_days
FROM
    reporting.sales_line
GROUP BY
    order_number,
    customer_key,
    store_key,
    order_date,
    delivery_date,
    currency_code;