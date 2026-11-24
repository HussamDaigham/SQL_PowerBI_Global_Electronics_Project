WITH revenue_per_year_per_category AS(
    SELECT
        EXTRACT(YEAR FROM order_date) AS order_year,
        category,
        SUM(estimated_revenue_usd) AS total_revenue,
        SUM(estimated_revenue_usd) FILTER(WHERE EXTRACT(MONTH FROM order_date) IN (11,12)) AS holiday_revenue
    FROM
    reporting.sales_line AS sl
    JOIN core.products AS c ON sl.product_key = c.product_key
    WHERE
        sl.order_date >= DATE '2016-01-01' AND
        sl.order_date < DATE '2021-01-01'
    GROUP BY
        order_year,
        category
)

SELECT
    category,
    SUM(total_revenue) AS sum_total_revenue,
    SUM(holiday_revenue) as sum_holiday_revenue,
    ROUND(
        SUM(holiday_revenue)::NUMERIC
        / NULLIF(SUM(total_revenue), 0),4) AS holiday_revenue_share
FROM
    revenue_per_year_per_category
GROUP BY
    category
ORDER BY
    holiday_revenue_share DESC NULLS LAST,
    category;

/*
Music, Movies and Audio Books had the highest holiday revenue share at 22.95%, just ahead of TV and Video at 22.88%.
Computers earned the most holiday revenue in dollars ($4.25 million), with a holiday share of 22.54%.
*/
