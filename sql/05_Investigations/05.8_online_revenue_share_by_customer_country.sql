WITH revenue_by_country_and_channel AS(
    SELECT
        country,
        SUM(o.estimated_revenue_usd) FILTER(WHERE o.store_key <> 0) AS physical_stores_revenue_usd,
        SUM(o.estimated_revenue_usd) FILTER(WHERE o.store_key = 0) AS online_revenue_usd,
        SUM(o.estimated_revenue_usd) AS total_revenue_usd
    FROM
        reporting.order_summary AS o
    JOIN core.customers AS c ON o.customer_key = c.customer_key
    GROUP BY
        c.country
)

SELECT
    *,
    ROUND(
        online_revenue_usd::NUMERIC
        / NULLIF(total_revenue_usd, 0), 4) AS online_revenue_share
FROM
    revenue_by_country_and_channel
ORDER BY
    online_revenue_share DESC NULLS LAST;

/*
Canada had the highest online revenue share of the eight customer markets at 23.55%, followed by Australia at 22.49%.
The United States generated the most online revenue at $6.11 million, with an online share of 20.44%.
*/