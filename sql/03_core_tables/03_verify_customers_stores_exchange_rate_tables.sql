SELECT
    'Customers' AS check_name,
    COUNT(*) AS actual,
    15266 AS expected
FROM
    core.customers

UNION ALL

SELECT
    'Napoli customers with state code NA',
    COUNT(*),
    10
FROM
    core.customers
WHERE
    country = 'Italy' AND
    state = 'Napoli' AND
    state_code = 'NA'

UNION ALL

SELECT
    'Stores',
    COUNT(*),
    67
FROM
    core.stores

UNION ALL

SELECT
    'Online store with no footprint',
    COUNT(*),
    1
FROM
    core.stores
WHERE
    store_key = 0 AND
    sales_channel = 'Online' AND
    square_meters IS NULL

UNION ALL

SELECT
    'Physical stores with no footprint',
    COUNT(*),
    0
FROM
    core.stores
WHERE
    store_key <> 0 AND
    square_meters IS NULL

UNION ALL

SELECT
    'Exchange rates',
    COUNT(*),
    11215
FROM
    core.exchange_rates;