# PCBM

This repository contains the source code for the paper ***Interpretable Machine Learning Models for Survival Prediction in Prostate Cancer Bone Metastases***. The code is organized into modules reflecting different stages of the machine learning workflow, from data preprocessing to model deployment. This repository aims to facilitate reproducibility and extendability of the research findings presented in the paper.

## Repository Structure

```
project-name/
├── README.md
├── data_preprocessing/
│   └── data_preprocessing.R
├── model_training_evaluation/
│   └── 1_train_test_split.R
│   └── 2_model_training_evaluation.R
├── model_deployment/
│   └── model_deployment.R
│   └── online_xgb_model_year1_survival.pkl
│   └── online_xgb_model_year3_survival.pkl
│   └── online_xgb_model_year5_survival.pkl
```

### Modules Overview

1. **Data Preprocessing** (`data_preprocessing/`):
   - **Script**: `data_preprocessing.R`
   - **Function**: This module handles the preparation of the dataset for analysis. It includes tasks such as data cleaning, feature transformation. Proper preprocessing ensures the quality and appropriateness of data for model training.
2. **Model Training and Evaluation** (`model_training_evaluation/`):
   - **Script**: `1_train_test_split.R`, `2_model_training_evaluation.R`
   - **Function**: This modules involves the training and tuning of various machine learning models including XGBoost, Logistic Regression (LR), Random Forest (RF), Support Vector Machine (SVM), k-Nearest Neighbors (KNN), and Decision Tree (ID3). It implements cross-validation for hyperparameter optimization and evaluates models using AUC scores for predicting survival in prostate cancer bone metastases.
3. **Model Deployment** (`model_deployment/`):
   - **Script**: `model_deployment.R`
   - **Function**: This module is designed to deploy the trained models into a user-friendly application interface using Shiny(local deployment). The app allows healthcare professionals and researchers to input patient data and obtain survival predictions, explicitly supporting decision-making in clinical settings.

### Notes

- **Consistency and Reproducibility**: This project spans multiple development cycles. While effort has been made to ensure consistency between implementation and the paper's results, there may be slight discrepancies.
- **Disclaimer**: The cloud-deployed Streamlit application is intended for research purposes and should not be used as a substitute for professional medical advice. Patients should consult healthcare professionals for clinical decisions.

## Paper Abstract

In the paper *Interpretable Machine Learning Models for Survival Prediction in Prostate Cancer Bone Metastases*, we explore the implementation and application of interpretable machine learning techniques to predict survival outcomes in patients with prostate cancer bone metastases. By leveraging a combination of state-of-the-art algorithms, our approach aims to enhance predictive accuracy while maintaining interpretability—an essential prerequisite for clinical use.

## Requirements
- **R** (version 4.0 or newer)
  - **Necessary R packages**: 
    - `xgboost` (version 1.4.1.1)
    - `caret` (version 7.0-1)
    - `pROC` (version 1.17.0.1)
    - `ggplot2` (version 3.3.5)
    - `shiny` (version 1.7.1)
    - Others specified within the scripts.

- **Python** (version 3.7 or newer)
  - **Necessary Python packages**:
    - `streamlit` (version 0.84.2)
    - `pandas` (version 1.3.1)
    - `joblib` (version 1.0.1)
    - `shap` (version 0.39.0)
    - `matplotlib` (version 3.4.3)
    - `seaborn` (version 0.11.2)
    - Others specified within the scripts.

## Running the Code

- Ensure the required datasets are available and correctly formatted.
- Execute each script sequentially to preprocess data, train the models, and deploy the application.
- Use the command line or an IDE environment to run the R scripts.

## Authors

- [Hua Zhang]
- [Boya Du]

## License

This project is licensed under the MIT License - see the [LICENSE](https://idealab.alibaba-inc.com/LICENSE) file for details.

## Acknowledgments

We acknowledge the support from [Alibaba Group] and [Boya Du].

------

This structured `README.md` not only provides essential information about your repository but also connects the code and the scientific inquiry addressed in your paper. It facilitates clarity for users, reviewers, and collaborators navigating your repository's components on GitHub.

