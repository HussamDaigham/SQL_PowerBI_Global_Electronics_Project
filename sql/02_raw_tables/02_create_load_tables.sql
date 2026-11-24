CREATE TABLE raw.sales(
    order_number TEXT,
    line_item TEXT,
    order_date TEXT,
    delivery_date TEXT,
    customer_key TEXT,
    store_key TEXT,
    product_key TEXT,
    quantity TEXT,
    currency_code TEXT
);


CREATE TABLE raw.customers(
    customer_key TEXT,
    gender TEXT,
    name TEXT,
    city TEXT,
    state_code TEXT,
    state TEXT,
    zip_code TEXT,
    country TEXT,
    continent TEXT,
    birthday TEXT
);


CREATE TABLE raw.products(
    product_key TEXT,
    product_name TEXT,
    brand TEXT,
    color TEXT,
    unit_cost_usd TEXT,
    unit_price_usd TEXT,
    subcategory_key TEXT,
    subcategory TEXT,
    category_key TEXT,
    category TEXT
);


CREATE TABLE raw.stores(
    store_key TEXT,
    country TEXT,
    state TEXT,
    square_meters TEXT,
    open_date TEXT
);


CREATE TABLE raw.exchange_rates(
    rate_date TEXT,
    currency_code TEXT,
    exchange_rates TEXT
);


\copy raw.sales FROM 'csv_files/original_data/Sales.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')
\copy raw.customers FROM 'csv_files/original_data/Customers.csv' WITH (FORMAT csv, HEADER true, ENCODING 'WIN1252')
\copy raw.products FROM 'csv_files/original_data/Products.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')
\copy raw.stores FROM 'csv_files/original_data/Stores.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')
\copy raw.exchange_rates FROM 'csv_files/original_data/Exchange_Rates.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')