BEGIN;

CREATE TABLE core.customers(
    customer_key INT NOT NULL PRIMARY KEY,
    gender TEXT NOT NULL,
    name TEXT NOT NULL,
    city TEXT NOT NULL,
    state_code TEXT NOT NULL,
    state TEXT NOT NULL,
    zip_code TEXT NOT NULL,
    country TEXT NOT NULL,
    continent TEXT NOT NULL,
    birthday DATE NOT NULL
);

INSERT INTO core.customers(
    customer_key,
    gender,
    name,
    city,
    state_code,
    state,
    zip_code,
    country,
    continent,
    birthday
)
SELECT
    customer_key::INT,
    gender,
    name,
    city,
    state_code,
    state,
    zip_code,
    country,
    continent,
    TO_DATE(birthday, 'MM/DD/YYYY')
FROM
    raw.customers;

COMMIT;