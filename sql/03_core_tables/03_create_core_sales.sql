BEGIN;

CREATE TABLE core.sales(
    order_number INT NOT NULL,
    line_item SMALLINT NOT NULL CHECK(line_item > 0),
    order_date DATE NOT NULL,
    delivery_date DATE,
    customer_key INT NOT NULL REFERENCES core.customers(customer_key),
    store_key INT NOT NULL REFERENCES core.stores(store_key),
    product_key INT NOT NULL REFERENCES core.products(product_key),
    quantity SMALLINT NOT NULL CHECK(quantity > 0),
    currency_code TEXT NOT NULL,

    PRIMARY KEY (order_number, line_item),
    FOREIGN KEY (order_date, currency_code) REFERENCES core.exchange_rates(rate_date, currency_code),
    CHECK (delivery_date >= order_date)
);

INSERT INTO core.sales(
    order_number,
    line_item,
    order_date,
    delivery_date,
    customer_key,
    store_key,
    product_key,
    quantity,
    currency_code
)
SELECT
    order_number::INT,
    line_item::SMALLINT,
    TO_DATE(order_date, 'MM/DD/YYYY'),
    TO_DATE(NULLIF(TRIM(delivery_date), ''), 'MM/DD/YYYY'),
    customer_key::INT,
    store_key::INT,
    product_key::INT,
    quantity::SMALLINT,
    currency_code
FROM
    raw.sales;

COMMIT;