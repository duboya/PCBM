# This script demonstrates how to load, process, and save datasets using R.

# It includes loading training and test data, splitting data for descriptive statistics,
# and saving processed datasets. The code utilizes libraries such as readr for CSV reading and caret for data partitioning.

# Load necessary libraries
library(readr)
library(caret)

# Load training data
X_train <- read.csv('path/to/X_train.csv', row.names = 1)
y_train <- read.csv('path/to/y_train.csv', row.names = 1)

# Load test data
X_test <- read.csv('path/to/X_test.csv', row.names = 1)
y_test <- read.csv('path/to/y_test.csv', row.names = 1)

# Print summary of loaded data
print(head(X_train))
print(head(y_train))

# Split data for descriptive statistics table
df <- read.csv('path/to/df_preprocessed.csv', header = TRUE)
partition <- createDataPartition(df[[1]], p = 0.7, list = FALSE)
trainSet <- df[partition, ]
testSet <- df[-partition, ]

# Save processed datasets
saveRDS(X_train, file = "X_train.rds")
saveRDS(y_train, file = "y_train.rds")
saveRDS(X_test, file = "X_test.rds")
saveRDS(y_test, file = "y_test.rds")


