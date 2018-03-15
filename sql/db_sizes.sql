﻿--Overall size
SELECT
    
    pg_size_pretty(total_size) AS total_size
FROM (
    SELECT
        sum(pg_total_relation_size(table_name)) AS total_size
    FROM (
        SELECT ('"' || table_schema || '"."' || table_name || '"') AS table_name
        FROM information_schema.tables
        WHERE table_schema = 'model_draft'
    ) AS all_tables
) AS pretty_sizes;

-- Table Sizes in model draft
SELECT
    table_name,
    pg_size_pretty(table_size) AS table_size,
    pg_size_pretty(indexes_size) AS indexes_size,
    pg_size_pretty(total_size) AS total_size
FROM (
    SELECT
        table_name,
        pg_table_size(table_name) AS table_size,
        pg_indexes_size(table_name) AS indexes_size,
        pg_total_relation_size(table_name) AS total_size
    FROM (
        SELECT ('"' || table_schema || '"."' || table_name || '"') AS table_name
        FROM information_schema.tables
        WHERE table_schema = 'model_draft'
    ) AS all_tables
    ORDER BY total_size DESC
) AS pretty_sizes

SELECT* FROM information_schema.tables
