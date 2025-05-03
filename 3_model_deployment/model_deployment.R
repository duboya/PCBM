# Model Deployment

# This Shiny application predicts survival probabilities for Prostate Cancer Based Metastasis (PCBM) patients using pre-trained XGBoost models for 1-Year, 3-Year, and 5-Year survival. 
# It accepts user inputs for various medical and demographic variables, performs predictions, and provides a diagnosis recommendation based on the prediction results.

# Load necessary libraries
library(shiny)
library(xgboost)
library(dplyr)

# Load models from RDS
model_year1 <- readRDS("xgb_model_year1_survival.rds")
model_year3 <- readRDS("xgb_model_year3_survival.rds")
model_year5 <- readRDS("xgb_model_year5_survival.rds")

# Define UI for Shiny app
ui <- fluidPage(
  titlePanel("PCBM Survival Probability Prediction"),
  sidebarLayout(
    sidebarPanel(
      numericInput("Liver.Metastases", "Liver Metastases:", value = 2),
      numericInput("T.Stage", "T Stage:", value = 0),
      numericInput("Gleason.Score", "Gleason Score:", value = 1),
      numericInput("Age.at.Diagnosis", "Age at Diagnosis:", value = 20),
      numericInput("Months.to.Treatment", "Months to Treatment:", value = 0),
      numericInput("Histological.Type", "Histological Type:", value = 39),
      numericInput("Surgery", "Surgery:", value = 0),
      numericInput("PSA", "PSA Level:", value = 973),
      numericInput("Marital.Status", "Marital Status:", value = 0),
      numericInput("N.Stage", "N Stage:", value = 3),
      numericInput("Grade", "Grade:", value = 0),
      numericInput("Race", "Race:", value = 3),
      numericInput("Chemotherapy", "Chemotherapy:", value = 0),
      numericInput("Brain.Metastases", "Brain Metastases:", value = 0),
      numericInput("Median.Household.Income", "Median Household Income:", value = 8),
      numericInput("Lung.Metastases", "Lung Metastases:", value = 2),
      numericInput("Radiotherapy", "Radiotherapy:", value = 2),
      actionButton("predict_button", "Predict Survival")
    ),
    mainPanel(
      h3("Prediction Results"),
      tableOutput("survival_probabilities"),
      h3("Diagnosis Recommendation"),
      textOutput("diagnosis_recommendation")
    )
  )
)

# Define server function
server <- function(input, output) {
  observeEvent(input$predict_button, {
    req(input$Liver.Metastases, input$T.Stage, input$Gleason.Score, 
        input$Age.at.Diagnosis, input$Months.to.Treatment, 
        input$Histological.Type, input$Surgery, input$PSA, 
        input$Marital.Status, input$N.Stage, 
        input$Grade, input$Race, 
        input$Chemotherapy, input$Brain.Metastases, 
        input$Median.Household.Income, input$Lung.Metastases, 
        input$Radiotherapy)
   
    # Create new data frame from user inputs
    new_data <- data.frame(
      Liver.Metastases = as.integer(input$Liver.Metastases),
      T.Stage = as.integer(input$T.Stage),
      Gleason.Score = as.integer(input$Gleason.Score),
      Age.at.Diagnosis = as.integer(input$Age.at.Diagnosis),
      Months.to.Treatment = as.integer(input$Months.to.Treatment),
      Histological.Type = as.integer(input$Histological.Type),
      Surgery = as.integer(input$Surgery),
      PSA = as.integer(input$PSA),
      Marital.Status = as.integer(input$Marital.Status),
      N.Stage = as.integer(input$N.Stage),
      Grade = as.integer(input$Grade),
      Race = as.integer(input$Race),
      Chemotherapy = as.integer(input$Chemotherapy),
      Brain.Metastases = as.integer(input$Brain.Metastases),
      Median.Household.Income = as.integer(input$Median.Household.Income),
      Lung.Metastases = as.integer(input$Lung.Metastases),
      Radiotherapy = as.integer(input$Radiotherapy)
    )

    # Predictions
    pred_year1 <- predict(model_year1, new_data, type = "prob")
    pred_year3 <- predict(model_year3, new_data, type = "prob")
    pred_year5 <- predict(model_year5, new_data, type = "prob")

    # Display survival probabilities
    output$survival_probabilities <- renderTable({
      data.frame(
        Year = c("1-Year", "3-Year", "5-Year"),
        Survival_Probability = round(c(pred_year1[1, 2], pred_year3[1, 2], pred_year5[1, 2]) * 100, 2)
      )
    }, striped = TRUE, hover = TRUE, bordered = TRUE)
   
    # Diagnosis recommendation
    output$diagnosis_recommendation <- renderText({
      if (pred_year1[1, 2] < 0.5) {
        "Higher risk of mortality; consult healthcare professionals immediately."
      } else {
        "Favorable survival prognosis; ensure regular check-ups."
      }
    })
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
