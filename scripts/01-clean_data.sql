-- Preamble 
-- Purpose: Verify columns and create cleaned version of data
-- Author: Chenika Bukes
-- Date: 14 November 2024
-- Contact: chenika.bukes@mail.utoronto.ca
-- License: MIT
-- Pre-requisites: raw and product tables should be present in the database

-- Step 1: Drop cleaned_data_lite table if it exists
DROP TABLE IF EXISTS cleaned_data_lite;

-- Step 2: Create cleaned_data_lite table by joining raw and product tables
CREATE TABLE cleaned_data_lite AS
SELECT
    raw.nowtime,
    product.vendor,          -- Using vendor from the product table
    raw.product_id,
    product.product_name,
    product.brand,
    raw.current_price,
    raw.old_price,
    product.units,
    raw.price_per_unit,
    raw.other
FROM
    raw
JOIN
    product ON raw.product_id = product.id
WHERE
    raw.current_price IS NOT NULL
    AND product.product_name IS NOT NULL;

-- Step 3: Clean price fields by removing commas if necessary
UPDATE cleaned_data_lite
SET 
    current_price = REPLACE(current_price, ',', ''),
    old_price = REPLACE(old_price, ',', ''),
    price_per_unit = REPLACE(price_per_unit, ',', '');

-- Step 4: Convert price fields to REAL type using CAST
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

-- Step 5: Export to CSV
.mode csv
.output data/02-analysis_data/cleaned_hammer_data.csv
SELECT * FROM final_cleaned_data_lite;
.output stdout
