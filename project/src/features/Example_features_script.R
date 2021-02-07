# Package Preparation
library(data.table)
set.seed(77)

# Read raw data tables
DT_train <- fread('./project/volume/data/raw/Stat_380_train.csv')
DT_test <- fread('./project/volume/data/raw/Stat_380_test.csv')

# Rewrite null values to zero
DT_train[is.na(DT_train)] <- 0
DT_test[is.na(DT_test)] <- 0

# Export the model-ready data tables
fwrite(DT_train, './project/volume/data/interim/Stat_380_train.csv')
fwrite(DT_test, './project/volume/data/interim/Stat_380_test.csv')