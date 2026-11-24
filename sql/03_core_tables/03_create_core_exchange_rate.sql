BEGIN;

CREATE TABLE core.exchange_rates(
    rate_date DATE NOT NULL,
    currency_code TEXT NOT NULL,
    exchange_rates NUMERIC NOT NULL CHECK(exchange_rates > 0),
    PRIMARY KEY (rate_date, currency_code)
);

INSERT INTO core.exchange_rates(
    rate_date,
    currency_code,
    exchange_rates
)
SELECT
    TO_DATE(rate_date, 'MM/DD/YYYY'),
    currency_code,
    exchange_rates::NUMERIC
FROM
    raw.exchange_rates;

COMMIT;