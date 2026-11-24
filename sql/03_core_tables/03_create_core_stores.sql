BEGIN;

CREATE TABLE core.stores(
    store_key INT NOT NULL PRIMARY KEY,
    country TEXT NOT NULL,
    state TEXT NOT NULL,
    square_meters INT CHECK(square_meters > 0),
    open_date DATE NOT NULL,
    sales_channel TEXT NOT NULL
);

INSERT INTO core.stores(
    store_key,
    country,
    state,
    square_meters,
    open_date,
    sales_channel
)
SELECT
    store_key::INT,
    country,
    state,
    NULLIF(TRIM(square_meters), '')::INT,
    TO_DATE(open_date, 'MM/DD/YYYY'),
    CASE
        WHEN store_key::INT = 0 THEN 'Online'
        ELSE 'Physical Store'
    END
FROM
    raw.stores;

COMMIT;