# Data Preprocessing

# This script handles data preprocessing for a set of medical records. It includes reading the data,
# feature transformation, data normalization, and preparation for subsequent analysis.

# Load necessary libraries
library(readr)  # For loading CSV
library(dplyr)  # For data manipulation

# Load the dataset from CSV
df <- read.csv('path/to/df_sample_feat_filtered.csv', row.names = 1)

# Function to print feature distribution
print_feature_distribution <- function(df, column_name) {
  # Prints the count and proportion of unique values in a dataframe column.
  cat(paste("Feature:", column_name, "\n"))
  value_counts <- table(df[[column_name]], useNA = "ifany")
  proportions <- prop.table(value_counts) * 100
  value_counts_df <- data.frame(Count = value_counts, `Proportion (%)` = proportions)
  print(value_counts_df)
  cat("\n")
}

# Helper functions for transformations
transform_t_stage <- function(stage) {
  # Transform T Stage values to defined categories.
  t_stage_map <- c('T0' = 'Others', 
                   'T1a' = 'T1', 'T1NOS' = 'T1', 'T1b' = 'T1', 'T1c' = 'T1',
                   'T2a' = 'T2', 'T2NOS' = 'T2', 'T2b' = 'T2', 'T2c' = 'T2',
                   'T3a' = 'T3', 'T3b' = 'T3', 'T3NOS' = 'T3',
                   'T4' = 'T4',
                   'TX' = 'Others', 'Blank(s)' = 'Others')
  return(ifelse(stage %in% names(t_stage_map), t_stage_map[stage], stage))
}

transform_gleason_score <- function(score) {
  # Categorize Gleason Score numerical values into specified categories.
  if (is.na(score)) return('unknown')
  score <- as.numeric(score)
  if (is.na(score)) return('unknown')
  if (score <= 7) {
    return('≤7')
  } else if (score %in% c(8, 9, 10)) {
    return(as.character(score))
  } else {
    return('Others')
  }
}

transform_age <- function(age_str) {
  # Convert age descriptor to numerical bins.
  age_map <- c('90+ years' = '90')
  age_str <- ifelse(age_str %in% names(age_map), age_map[age_str], age_str)
  age_num <- as.numeric(age_str)
  age_labels <- c("< 50", "50–59", "60–69", "70–79", "80+")
  return(cut(age_num, breaks = c(0, 50, 60, 70, 80, Inf), labels = age_labels, right = FALSE))
}

transform_months_to_treatment <- function(months) {
  # Normalize Months to Treatment values and categorize.
  if (months == 'Blank(s)') return('>=1')
  months <- as.numeric(months)
  return(cut(months, breaks = c(-1, 0, Inf), labels = c("0", ">=1")))
}

classify_treatment <- function(radio_type) {
  # Classifies radiotherapy treatments.
  radio_categories <- c('Beam radiation' = 'Yes', 
                        'Combination of beam with implants or isotopes' = 'Yes',
                        'Radioactive implants (includes brachytherapy) (...)' = 'Yes',
                        'Radioisotopes (1988+)' = 'Yes',
                        'Refused (1988+)' = 'No')
  return(ifelse(radio_type %in% names(radio_categories), radio_categories[radio_type], 'Unknown'))
}

# Feature transformations
# T Stage
df$T.Stage <- sapply(df$T.Stage, transform_t_stage)

# Gleason Score
df$Gleason.Score <- sapply(as.character(df$Gleason.Score), transform_gleason_score)

# Age at Diagnosis
df$Age.at.Diagnosis <- sapply(df$Age.at.Diagnosis, transform_age)

# Months to Treatment
df$Months.to.Treatment <- sapply(df$Months.to.Treatment, transform_months_to_treatment)

# Histological Type
df$Histological.Type <- ifelse(df$Histological.Type == '8140', 'Adenocarcinoma', 'Others')

# Surgery Transformation
df$Surgery <- ifelse(df$Surgery == '0', 'No', 'Yes')

# PSA Transformation
psa_map <- c('98.0 ng/ml or greater' = '98', 'Not documented; not assessed; unknown' = 'unknown',
             'Test ordered, results not in chart' = 'unknown')
df$PSA <- sapply(gsub("ng/ml or greater", "", df$PSA), function(x) as.numeric(ifelse(x %in% names(psa_map), psa_map[[x]], x)))
df$PSA <- cut(df$PSA, breaks = c(-Inf, 10, Inf), labels = c('≤ 10', '>10'))
df$PSA <- factor(df$PSA, levels = c('≤ 10', '>10', 'unknown'))
df$PSA[is.na(df$PSA)] <- 'unknown'

# Marital Status
marital_map <- c('Married (including common law)' = 'Married', 'Single (never married)' = 'Single')
df$Marital.Status <- ifelse(df$Marital.Status %in% names(marital_map), marital_map[df$Marital.Status], 'Others')

# Race
race_values <- c('Black', 'White')
df$Race <- ifelse(df$Race %in% race_values, df$Race, 'Others')

# N Stage
df$N.Stage <- ifelse(df$N.Stage %in% c('NX', 'Blank(s)'), 'Others', df$N.Stage)

# Grade Transformation
grade_map <- c('Poorly differentiated; Grade III' = 'III', 'Moderately differentiated; Grade II' = 'II',
                'Well differentiated; Grade I' = 'I', 'Undifferentiated; anaplastic; Grade IV' = 'IV')
df$Grade <- ifelse(df$Grade %in% names(grade_map), grade_map[df$Grade], df$Grade)

# Median Household Income
income_values <- c('$75,000+', '$65,000 - $69,999', '$70,000 - $74,999')
df$Median.Household.Income <- ifelse(df$Median.Household.Income %in% income_values, df$Median.Household.Income, 'Others')

# M Stage
m_stage_values <- c('M1a', 'M1b', 'M1c', 'M1NOS')
df$M.Stage <- ifelse(df$M.Stage %in% m_stage_values, 'M1', 'Others')

# Radiotherapy Transformation
df$Radiotherapy <- sapply(df$Radiotherapy, classify_treatment)

# Print feature distributions
for (column_name in names(df)) {
  print_feature_distribution(df, column_name)
}
