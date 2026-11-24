CREATE OR REPLACE VIEW reporting.date_dimension AS
WITH date_bounds AS (
    SELECT
        DATE_TRUNC('year', MIN(order_date))::DATE AS first_day,
        (DATE_TRUNC('year', GREATEST(MAX(order_date), MAX(delivery_date))) + INTERVAL '1 year - 1 day')::DATE AS last_day,
        MAX(order_date) AS last_order_date
    FROM
        core.sales
),

calendar_days AS (
    SELECT
        d.calendar_date::date AS calendar_date,
        b.last_order_date
    FROM
        date_bounds AS b
    CROSS JOIN GENERATE_SERIES(
        b.first_day::TIMESTAMP,
        b.last_day::TIMESTAMP,
        INTERVAL '1 day'
    ) AS d(calendar_date)
)

SELECT
    calendar_date,
    EXTRACT(YEAR FROM calendar_date)::INT AS calendar_year,
    EXTRACT(QUARTER FROM calendar_date)::INT AS quarter_number,
    EXTRACT(MONTH FROM calendar_date)::INT AS month_number,
    TO_CHAR(calendar_date, 'Mon') AS month_name,
    DATE_TRUNC('month', calendar_date)::DATE AS month_start,
    TO_CHAR(calendar_date, 'YYYY-MM') AS year_month,
    calendar_date > last_order_date AS is_after_last_order_date
FROM
    calendar_days;