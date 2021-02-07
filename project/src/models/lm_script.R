# Package Preparation
library(caret)
library(data.table)
library(Metrics)
library(tidyverse)

set.seed(77)

# Read intermediate data tables
train <- fread('./project/volume/data/interim/Stat_380_train.csv')
test <- fread('./project/volume/data/interim/Stat_380_test.csv')

# Preset the SalePrice column in test data for convenience
test <- test %>% add_column(SalePrice = 0)

# Save SalePrice column for train data
train_y <- train$SalePrice

# Combine both train and test data for dummy variables
master <- rbind(train,test)

dummies <- dummyVars(SalePrice ~ ., data = master)
train <- predict(dummies, newdata = train)
test <- predict(dummies, newdata = test)

# Reformat after dummyVars and add back response Var
train <- data.table(train)
train$SalePrice <- train_y
test <- data.table(test)

# Fit a linear model
lm_model <- lm(SalePrice ~ ., data = train)

# Assess model
summary(lm_model)

# Save model
saveRDS(dummies, "./project/volume/models/SalePrice_lm.dummies")
saveRDS(lm_model, "./project/volume/models/SalePrice_lm.model")

test$SalePrice <- predict(lm_model, newdata = test)

# Select needed columns to fulfill submission requirements
submit <- test[,.(Id, SalePrice)]

# Write out a submission
fwrite(submit, "./project/volume/data/processed/submit_lm.csv")