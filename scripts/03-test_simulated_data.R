#### Preamble ####
# Purpose: Tests for simulated grocery data
# Author: Chenika Bukes
# Date: 21 November 2024
# Contact: chenika.bukes@mail.utoronto.ca
# License: MIT
# Pre-requisites: Ensure that the simulated data has been successfully created
# and saved as "data/00-simulated_data/simulated_grocery_data.csv"
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)
library(testthat)

simulated_data <- read_csv("data/00-simulated_data/simulated_grocery_data.csv")


#### Test data ####
# Test that the dataset has rows - it should not be empty
test_that("dataset has rows", {
  expect_gt(nrow(simulated_data), 0)
})

# Test that the dataset has 7 columns as per the simulation script
test_that("dataset has 7 columns", {
  expect_equal(ncol(simulated_data), 7)
})

# Test that the 'vendor' column is character type
test_that("'vendor' is character", {
  expect_type(simulated_data$vendor, "character")
})

# Test that the 'product_name' column is character type
test_that("'product_name' is character", {
  expect_type(simulated_data$product_name, "character")
})

# Test that 'current_price' and 'old_price' columns are numeric type
test_that("'current_price' is numeric", {
  expect_type(simulated_data$current_price, "double")
})

test_that("'old_price' is numeric", {
  expect_type(simulated_data$old_price, "double")
})

# Test that 'current_price' values are positive
test_that("'current_price' values are positive", {
  expect_true(all(simulated_data$current_price > 0, na.rm = TRUE))
})

# Test that 'old_price' values are greater than or equal to 'current_price'
test_that("'old_price' values are greater than or equal to 'current_price'", {
  expect_true(all(simulated_data$old_price >= simulated_data$current_price, na.rm = TRUE))
})

# Test that 'price_per_unit' column has numeric type
test_that("'price_per_unit' is numeric", {
  expect_type(simulated_data$price_per_unit, "double")
})

# Test that 'price_per_unit' has positive values
test_that("'price_per_unit' has positive values", {
  expect_true(all(simulated_data$price_per_unit > 0, na.rm = TRUE))
})

# Test that the 'timestamp' column has valid date-time format
test_that("'timestamp' column has valid date-time format", {
  expect_true(all(!is.na(as.POSIXct(simulated_data$timestamp, format = "%Y-%m-%d %H:%M:%S"))))
})

# Test that the 'vendor' column has at least 7 unique vendors
test_that("'vendor' column has 7 unique vendors", {
  expect_equal(length(unique(simulated_data$vendor)), 7)
})

# Test that the 'product_name' column has at least 7 unique products
test_that("'product_name' column has 7 unique products", {
  expect_equal(length(unique(simulated_data$product_name)), 7)
})

# Test that there are no missing values in critical columns
test_that("no missing values in critical columns", {
  expect_true(all(!is.na(simulated_data$vendor)))
  expect_true(all(!is.na(simulated_data$product_name)))
  expect_true(all(!is.na(simulated_data$current_price)))
  expect_true(all(!is.na(simulated_data$timestamp)))
})
