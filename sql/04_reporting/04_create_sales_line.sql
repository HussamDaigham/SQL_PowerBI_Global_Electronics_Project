CREATE OR REPLACE VIEW reporting.sales_line AS
SELECT
    s.order_number,
    s.line_item,
    s.order_date,
    s.delivery_date,
    s.customer_key,
    s.store_key,
    s.product_key,
    s.quantity,
    s.currency_code,
    s.quantity * p.unit_price_usd AS estimated_revenue_usd,
    s.quantity * p.unit_cost_usd AS estimated_cogs_usd,
    s.quantity * (p.unit_price_usd - p.unit_cost_usd) AS estimated_gross_profit_usd
FROM
    core.sales AS s
JOIN core.products AS p ON s.product_key = p.product_key;