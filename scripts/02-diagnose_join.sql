-- Preamble 
-- Purpose: Create a clean version of the data by joining product and raw tables
-- Author: Chenika Bukes
-- Date: 14 November 2024
-- Contact: chenika.bukes@mail.utoronto.ca
-- License: MIT
-- Pre-requisites: The SQLite database should contain raw and product tables

-- Step 1: Inspect table structures to confirm columns
PRAGMA table_info(raw);
PRAGMA table_info(product);

-- Step 2: Drop the cleaned_data_lite table if it exists
DROP TABLE IF EXISTS cleaned_data_lite;

-- Step 3: Create cleaned_data_lite table by joining raw and product on matching IDs
CREATE TABLE cleaned_data_lite AS
SELECT
    r.nowtime,
    -- Use a fallback vendor name if `vendor` does not exist in `raw`
    COALESCE(r.vendor, p.vendor) AS vendor,
    r.product_id,
    p.product_name,
    p.brand,
    r.current_price,
    r.old_price,
    p.units,
    r.price_per_unit,
    r.other
FROM
    raw AS r
JOIN
    product AS p ON r.product_id = p.id
WHERE
    r.current_price IS NOT NULL
    AND p.product_name IS NOT NULL;

-- Step 4: Clean price fields by removing commas, if necessary
UPDATE cleaned_data_lite
SET 
    current_price = REPLACE(current_price, ',', ''),
    old_price = REPLACE(old_price, ',', ''),
    price_per_unit = REPLACE(price_per_unit, ',', '');

-- Step 5: Convert price fields to REAL data type (using CAST)
DROP TABLE IF EXISTS final_cleaned_data_lite;
CREATE TABLE final_cleaned_data_lite AS
SELECT
    nowtime,
    vendor,
    product_id,
    product_name,
    brand,
    CAST(current_price AS REAL) AS current_price,
    CAST(old_price AS REAL) AS old_price,
    units,
    CAST(price_per_unit AS REAL) AS price_per_unit,
    other
FROM cleaned_data_lite;

-- Step 6: Export cleaned data to CSV
.mode csv
.output data/02-analysis_data/cleaned_hammer_data.csv
SELECT * FROM final_cleaned_data_lite;
.output stdout
