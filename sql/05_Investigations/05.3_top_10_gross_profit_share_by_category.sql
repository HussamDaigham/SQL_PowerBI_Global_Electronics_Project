WITH product_category_gross_profit AS(
    SELECT
        s.product_key,
        category,
        product_name,
        SUM(estimated_gross_profit_usd) AS estimated_gross_profit_per_product_usd
    FROM
        reporting.sales_line AS s
    JOIN core.products AS p ON s.product_key = p.product_key
    GROUP BY
        s.product_key,
        p.category,
        product_name
),

profit_rank_by_category AS(
    SELECT
        product_key,
        product_name,
        category,
        estimated_gross_profit_per_product_usd,
        ROW_NUMBER() OVER(
            PARTITION BY category
            ORDER BY estimated_gross_profit_per_product_usd DESC,
            product_key
        ) AS profit_rank
    FROM
        product_category_gross_profit
)

SELECT
    category,
    SUM(estimated_gross_profit_per_product_usd) AS total_gross_profit_usd,
    SUM(estimated_gross_profit_per_product_usd) FILTER(WHERE profit_rank <= 10) AS top_10_gross_profit_usd,
    ROUND(
        SUM(estimated_gross_profit_per_product_usd) FILTER(WHERE profit_rank <= 10)::NUMERIC
        / NULLIF(SUM(estimated_gross_profit_per_product_usd), 0), 4) AS top_10_gross_profit_share
FROM
    profit_rank_by_category
GROUP BY
    category
ORDER BY
    category;
