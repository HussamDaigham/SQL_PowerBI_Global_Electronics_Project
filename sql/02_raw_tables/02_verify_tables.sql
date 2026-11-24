SELECT
    'sales' AS check_name,
    COUNT(*) AS actual,
    62884 AS expected
FROM
    raw.sales

UNION ALL

SELECT
    'customers',
    COUNT(*),
    15266
FROM
    raw.customers

UNION ALL

SELECT
    'products',
    COUNT(*),
    2517
FROM
    raw.products

UNION ALL

SELECT
    'stores',
    COUNT(*),
    67
FROM
    raw.stores

UNION ALL

SELECT
    'exchange_rates',
    COUNT(*),
    11215
FROM
    raw.exchange_rates

UNION ALL

SELECT
    'Napoli customers with state code NA',
    COUNT(*),
    10
FROM
    raw.customers
WHERE
    country = 'Italy' AND
    state = 'Napoli' AND
    state_code = 'NA';