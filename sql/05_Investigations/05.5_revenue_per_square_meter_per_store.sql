WITH established_physical_stores AS(
    SELECT
        store_key,
        country,
        open_date,
        square_meters
    FROM
        core.stores
    WHERE
        store_key <> 0 AND
        square_meters > 0 AND
        open_date <= DATE '2019-01-01'
),

established_physical_stores_revenue AS(
    SELECT
        store_key,
        SUM(estimated_revenue_usd) AS estimated_revenue_usd_per_store
    FROM
        reporting.order_summary
    WHERE
        store_key <> 0 AND
        order_date >= DATE '2020-01-01' AND
        order_date <  DATE '2021-01-01'
    GROUP BY
        store_key
)

/*
SELECT
    SUM(estimated_revenue_usd_per_store)
FROM
    established_physical_stores_revenue
*/

SELECT
    eps.store_key,
    country,
    square_meters,
    estimated_revenue_usd_per_store,
    ROUND(estimated_revenue_usd_per_store::NUMERIC
    / NULLIF(square_meters, 0),4) AS revenue_per_square_meter
FROM
    established_physical_stores AS eps
LEFT JOIN established_physical_stores_revenue AS epsr ON eps.store_key = epsr.store_key
ORDER BY
    revenue_per_square_meter DESC NULLS LAST,
    eps.store_key
;


/*
Store 66 in the United States leads at $244.18 per square meter ($205,111.88 / 840).
Store 43 brought in more total revenue ($263,444.43), but its larger floor area put it second at $221.38 per square meter
*/