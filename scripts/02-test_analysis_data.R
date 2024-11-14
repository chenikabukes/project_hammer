#### Preamble ####
# Purpose: Tests for cleaned hammer data
# Author: Chenika Bukes
# Date: 14 November 2024
# Contact: chenika.bukes@mail.utoronto.ca
# License: MIT
# Pre-requisites: Ensure that the cleaned data has been successfully created
# and saved as "data/02-analysis_data/cleaned_hammer_data.csv"
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)
library(testthat)

analysis_data <- read_csv("data/02-analysis_data/cleaned_hammer_data.csv")


#### Test data ####
# Test that the dataset has rows - it should not be empty
test_that("dataset has rows", {
  expect_gt(nrow(analysis_data), 0)
})

# Test that the dataset has 10 columns as per the SQL script
test_that("dataset has 10 columns", {
  expect_equal(ncol(analysis_data), 10)
})

# Test that the 'vendor' column is character type
test_that("'vendor' is character", {
  expect_type(analysis_data$vendor, "character")
})

# Test that 'current_price' and 'old_price' columns are numeric type
test_that("'current_price' is numeric", {
  expect_type(analysis_data$current_price, "double")
})

test_that("'old_price' is numeric", {
  expect_type(analysis_data$old_price, "double")
})

# Test that 'nowtime' column has values that can be converted to Date format
test_that("'nowtime' column has valid date format", {
  expect_true(all(!is.na(as.Date(analysis_data$nowtime, format="%Y-%m-%d %H:%M:%S"))))
})

# Test that there are no missing values in the 'product_name' column
test_that("no missing values in 'product_name'", {
  expect_true(all(!is.na(analysis_data$product_name)))
})

# Test that 'current_price' has reasonable positive values (greater than 0)
test_that("'current_price' has positive values", {
  expect_true(all(analysis_data$current_price > 0, na.rm = TRUE))
})

# Test that 'vendor' column contains at least two unique vendors
test_that("'vendor' column has multiple unique values", {
  expect_gt(length(unique(analysis_data$vendor)), 1)
})

# Test that 'units' column does not contain any empty strings
test_that("'units' column has no empty strings", {
  expect_false(any(analysis_data$units == ""))
})

# Test that 'price_per_unit' column has numeric type
test_that("'price_per_unit' is numeric", {
  expect_type(analysis_data$price_per_unit, "double")
})

# Test that 'product_id' column is integer and has unique values
test_that("'product_id' is integer and unique", {
  expect_type(analysis_data$product_id, "integer")
  expect_equal(length(unique(analysis_data$product_id)), nrow(analysis_data))
})
