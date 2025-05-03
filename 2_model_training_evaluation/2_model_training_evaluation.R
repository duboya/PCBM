# This script is designed to train, evaluate, and save machine learning models using R. 

# It supports multiple algorithms: XGBoost, Logistic Regression, Random Forest, SVM, k-Nearest Neighbors, and Decision Tree (ID3). 
# The training process includes hyperparameter tuning with cross-validation, and results are evaluated using AUC scores.

# Load necessary libraries
library(caret)
library(pROC)

# Suppress warnings
options(warn = -1)

# Define target labels
labels <- c("year1_survival", "year3_survival", "year5_survival")

# Initialize lists for models, parameters, and scores
models <- list()
best_params <- list()
auc_scores <- list()

# Train Control
train_control <- trainControl(method = "cv",
                              number = 5,
                              classProbs = TRUE,
                              summaryFunction = twoClassSummary,
                              verboseIter = TRUE)

# Function to train and evaluate the model
train_and_evaluate <- function(label, method, tuneGrid, data, trainCtl) {
  set.seed(42)
  model <- train(as.formula(paste(label, "~ .")),
                 data = data,
                 method = method,
                 metric = "ROC",
                 trControl = trainCtl,
                 tuneGrid = tuneGrid)
  
  prob_pred <- predict(model, X_test, type = "prob")[,2]
  auc_score <- roc(y_test[[label]], prob_pred)$auc
  
  list(model = model, auc_score = auc_score, bestTune = model$bestTune)
}

# Loop over labels to apply different models
for (label in labels) {
  y_train[[label]] <- factor(y_train[[label]], levels = c(0, 1), labels = c("Class0", "Class1"))
  
  # Combine features and labels for training
  train_data <- cbind(X_train, y_train[label])
  
  # ---- XGBoost ----
  xgb_grid <- expand.grid(nrounds = c(10, 50, 100, 200, 500),
                          max_depth = c(1, 2, 3, 5, 7, 10),
                          eta = c(0.01, 0.1, 0.3), 
                          gamma = 0, 
                          colsample_bytree = 1,
                          min_child_weight = 1,
                          subsample = 1)
  
  xgb_result <- train_and_evaluate(label, "xgbTree", xgb_grid, train_data, train_control)
  models[[paste0(label, "_xgb")]] <- xgb_result$model
  best_params[[paste0(label, "_xgb")]] <- xgb_result$bestTune
  auc_scores[[paste0(label, "_xgb")]] <- xgb_result$auc_score
  
  # ---- Logistic Regression ----
  lr_result <- train_and_evaluate(label, "glm", data = train_data, trainCtl = train_control)
  models[[paste0(label, "_lr")]] <- lr_result$model
  best_params[[paste0(label, "_lr")]] <- lr_result$bestTune
  auc_scores[[paste0(label, "_lr")]] <- lr_result$auc_score
  
  # ---- Random Forest ----
  rf_grid <- expand.grid(mtry = c(2, 3, 4, 5))
  
  rf_result <- train_and_evaluate(label, "rf", rf_grid, train_data, train_control)
  models[[paste0(label, "_rf")]] <- rf_result$model
  best_params[[paste0(label, "_rf")]] <- rf_result$bestTune
  auc_scores[[paste0(label, "_rf")]] <- rf_result$auc_score
  
  # ---- SVM ----
  svm_grid <- expand.grid(sigma = c(0.01, 0.1), C = c(0.1, 1, 10))
  
  svm_result <- train_and_evaluate(label, "svmRadial", svm_grid, train_data, train_control)
  models[[paste0(label, "_svm")]] <- svm_result$model
  best_params[[paste0(label, "_svm")]] <- svm_result$bestTune
  auc_scores[[paste0(label, "_svm")]] <- svm_result$auc_score
  
  # ---- k-Nearest Neighbors ----
  knn_grid <- expand.grid(k = c(3, 5, 7, 9))
  
  knn_result <- train_and_evaluate(label, "knn", knn_grid, train_data, train_control)
  models[[paste0(label, "_knn")]] <- knn_result$model
  best_params[[paste0(label, "_knn")]] <- knn_result$bestTune
  auc_scores[[paste0(label, "_knn")]] <- knn_result$auc_score
  
  # ---- Decision Tree (ID3) ----
  dt_grid <- expand.grid(cp = c(0.01, 0.05, 0.1))
  
  dt_result <- train_and_evaluate(label, "rpart", dt_grid, train_data, train_control)
  models[[paste0(label, "_dt")]] <- dt_result$model
  best_params[[paste0(label, "_dt")]] <- dt_result$bestTune
  auc_scores[[paste0(label, "_dt")]] <- dt_result$auc_score
}

# Save the results
for (label in labels) {
  for (method in c("xgb", "lr", "rf", "svm", "knn", "dt")) {
    file_name <- paste0(method, "_model_", label, ".rds")
    saveRDS(models[[paste0(label, "_", method)]], file = file_name)
  }
}

# Reset warning settings
options(warn = 0)
