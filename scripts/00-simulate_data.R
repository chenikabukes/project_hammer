#### Preamble ####
# Purpose: Simulates a dataset of grocery prices across vendors and products, 
#          including pricing strategies and sale trends.
# Author: Chenika Bukes
# Date: 21 November 2024
# Contact: chenika.bukes@utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `project_hammer` R project.

#### Workspace setup ####
library(tidyverse)
set.seed(6666)

#### Simulate data ####

# Define vendors
vendors <- c("Loblaws", "Metro", "NoFrills", "SaveOnFoods", "TandT", "Voila", "Walmart")

# Define product types
products <- c("Bread", "Milk", "Eggs", "Cheese", "Chicken", "Rice", "Cereal")

# Simulate a dataset with random prices, sales, and timestamps
simulated_data <- tibble(
  product_id = 1:500,  # Simulate 500 unique product IDs
  product_name = sample(products, size = 500, replace = TRUE),  # Random product assignment
  vendor = sample(vendors, size = 500, replace = TRUE),  # Random vendor assignment
  current_price = round(runif(500, 1, 15), 2),  # Random current prices between $1 and $15
  old_price = current_price + round(runif(500, 0, 5), 2),  # Old price is slightly higher
  sale_status = sample(c("On Sale", "Not on Sale"), size = 500, replace = TRUE, prob = c(0.3, 0.7)),  # 30% products on sale
  timestamp = sample(seq(as.POSIXct("2024-01-01"), as.POSIXct("2024-12-31"), by = "day"), size = 500, replace = TRUE)  # Random dates in 2024
)

# Add price per unit (simulating per kg/lb or per item pricing)
simulated_data <- simulated_data %>%
  mutate(
    price_per_unit = current_price / runif(500, 0.5, 2),  # Random unit sizes
    price_per_unit = round(price_per_unit, 2)  # Round to two decimal places
  )

#### Save data ####
write_csv(simulated_data, "./data/00-simulated_data/simulated_grocery_data.csv")
