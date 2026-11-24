SELECT
    current_database() AS database_name,
    schema_name
FROM information_schema.schemata
WHERE schema_name IN ('raw', 'core', 'reporting')
ORDER BY schema_name;