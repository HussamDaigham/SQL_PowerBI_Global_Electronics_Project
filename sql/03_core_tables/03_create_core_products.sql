BEGIN;

CREATE TABLE core.products(
    product_key INT NOT NULL PRIMARY KEY,
    product_name TEXT NOT NULL,
    brand TEXT NOT NULL,
    color TEXT NOT NULL,
    unit_cost_usd NUMERIC(12,2) NOT NULL CHECK(unit_cost_usd > 0),
    unit_price_usd NUMERIC(12,2) NOT NULL CHECK(unit_price_usd > 0),
    subcategory_key TEXT NOT NULL,
    subcategory TEXT NOT NULL,
    category_key TEXT NOT NULL,
    category TEXT NOT NULL
);

INSERT INTO core.products(
    product_key,
    product_name,
    brand,
    color,
    unit_cost_usd,
    unit_price_usd,
    subcategory_key,
    subcategory,
    category_key,
    category
)
SELECT
    product_key::INT,
    product_name,
    brand,
    color,
    REPLACE(REPLACE(unit_cost_usd, '$', ''), ',', '')::NUMERIC(12,2),
    REPLACE(REPLACE(unit_price_usd, '$', ''), ',', '')::NUMERIC(12,2),
    subcategory_key,
    subcategory,
    category_key,
    category
FROM
    raw.products;

COMMIT;