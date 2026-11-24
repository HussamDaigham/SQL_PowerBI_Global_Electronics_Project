SELECT
    (SELECT COUNT(*) FROM raw.products) AS raw_rows,
    COUNT(*) AS core_rows,
    COUNT(*) FILTER (
        WHERE unit_cost_usd > unit_price_usd
    ) AS products_priced_below_cost
FROM core.products;