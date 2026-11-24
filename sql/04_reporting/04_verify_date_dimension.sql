SELECT
    MIN(calendar_date) AS first_day,
    MAX(calendar_date) AS last_day,
    COUNT(*) AS calendar_rows,
    COUNT(DISTINCT calendar_date) AS unique_dates,
    MAX(calendar_date) - MIN(calendar_date) + 1 AS days_in_span,
    MAX(calendar_date) FILTER (
        WHERE NOT is_after_last_order_date
    ) AS last_order_date,
    COUNT(*) FILTER (
        WHERE is_after_last_order_date
    ) AS days_after_last_order
FROM
    reporting.date_dimension;