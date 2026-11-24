-- Composite index to optimize customer repeat-purchase lookups.
-- Supports filtering by customer_key and a 90-day order_date range.
-- Created after EXPLAIN ANALYZE revealed repeated sequential scans.

CREATE INDEX IF NOT EXISTS idx_sales_customer_order_date
ON core.sales (customer_key, order_date);