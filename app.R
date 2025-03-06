# Load required libraries
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(tidytuesdayR)
library(lubridate)
library(nnet)  # Multinomial logistic regression

# Load the TidyTuesday dataset for March 4, 2025
tuesdata <- tidytuesdayR::tt_load('2025-03-04') 
longbeach_df <- tuesdata$longbeach  

# Convert intake_date to Date format
longbeach_df$intake_date <- as.Date(longbeach_df$intake_date)

# Prepare data for modeling (Replace intake_cond with intake_type)
model_data <- longbeach_df %>%
  select(animal_type, intake_type, sex, outcome_type) %>%
  filter(!is.na(outcome_type))  # Remove missing outcomes

# Convert categorical variables to factors
model_data <- model_data %>%
  mutate(across(everything(), as.factor))

# Train a multinomial logistic regression model
set.seed(123)  # For reproducibility
model <- multinom(outcome_type ~ animal_type + intake_type + sex, data = model_data)

# UI
ui <- dashboardPage(
  dashboardHeader(title = "Long Beach Animal Shelter"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Animal Types", tabName = "animal_types", icon = icon("paw")),
      menuItem("Intake Types", tabName = "intake_types", icon = icon("sign-in-alt")),
      menuItem("Predict Outcome", tabName = "predict", icon = icon("chart-line")),
      dateRangeInput("dateRange", "Select Date Range:",
                     start = min(longbeach_df$intake_date, na.rm = TRUE),
                     end = max(longbeach_df$intake_date, na.rm = TRUE))
    )
  ),
  
  dashboardBody(
    tabItems(
      # Dashboard Tab
      tabItem(tabName = "dashboard",
              h2("Welcome to the Long Beach Animal Shelter Dashboard"),
              p("Use the tabs on the left to explore the data."),
              p("Filter the data by date using the sidebar.")),
      
      # Animal Types Tab
      tabItem(tabName = "animal_types",
              fluidRow(
                box(title = "Count of Animal Types", status = "primary", solidHeader = TRUE,
                    plotOutput("animalTypePlot"), width = 12)
              )),
      
      # Intake Types Tab
      tabItem(tabName = "intake_types",
              fluidRow(
                box(title = "Count of Intake Types", status = "warning", solidHeader = TRUE,
                    plotOutput("intakeTypePlot"), width = 12)
              )),
      
      # Prediction Tab
      tabItem(tabName = "predict",
              h2("Predict Animal Outcome"),
              fluidRow(
                column(4,
                       selectInput("animal_type", "Animal Type", choices = unique(model_data$animal_type)),
                       selectInput("intake_type", "Intake Type", choices = unique(model_data$intake_type)),
                       selectInput("sex", "Sex", choices = unique(model_data$sex)),
                       actionButton("predict_btn", "Predict Outcome")
                ),
                column(8,
                       box(title = "Prediction Result", status = "info", solidHeader = TRUE,
                           textOutput("prediction"), width = 12)
                )
              ))
    )
  )
)

# Server Logic
server <- function(input, output) {
  
  # Reactive dataset filtered by date
  filtered_data <- reactive({
    longbeach_df %>%
      filter(intake_date >= input$dateRange[1] & intake_date <= input$dateRange[2])
  })
  
  # Bar Chart for Animal Types
  output$animalTypePlot <- renderPlot({
    ggplot(filtered_data(), aes(x = animal_type)) +
      geom_bar(fill = "steelblue") +
      theme_minimal() +
      labs(title = "Count of Animal Types",
           x = "Animal Type",
           y = "Count")
  })
  
  # Bar Chart for Intake Types
  output$intakeTypePlot <- renderPlot({
    ggplot(filtered_data(), aes(x = intake_type)) +
      geom_bar(fill = "tomato") +
      theme_minimal() +
      labs(title = "Count of Intake Types",
           x = "Intake Type",
           y = "Count") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  # Predict Animal Outcome
  observeEvent(input$predict_btn, {
    new_data <- data.frame(
      animal_type = factor(input$animal_type, levels = levels(model_data$animal_type)),
      intake_type = factor(input$intake_type, levels = levels(model_data$intake_type)),
      sex = factor(input$sex, levels = levels(model_data$sex))
    )
    
    prediction <- predict(model, new_data, type = "class")
    
    output$prediction <- renderText({
      paste("Predicted Outcome:", prediction)
    })
  })
  
}

# Run the App
shinyApp(ui = ui, server = server)
