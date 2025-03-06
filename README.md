# **Long Beach Animal Shelter Outcome Prediction App** / LBSO
---

📊 **Shiny App for Predicting Shelter Outcomes Using Machine Learning**  

## **Overview**
This **Machine Learning app** predicts the likely outcome of animals at the **Long Beach Animal Shelter** using **seven years of historical intake and outcome data** from the [Tidy Tuesday Project](https://github.com/rfordatascience/tidytuesday). It employs **multinomial logistic regression** to analyze intake trends and provide predictions.

## **Features**
- **Machine Learning Prediction:** Uses historical intake data to predict whether an animal will be **adopted, transferred, returned to owner, or euthanized**.
- **Interactive Shiny Dashboard:**  
  - View intake trends by **animal type** and **intake type**.  
  - Filter records by **date range**.  
  - Predict outcomes based on user-selected attributes.  
- **Data Visualization:**  
  - Bar charts display intake trends over time.
- 🚀 **Planned Enhancements:**  
  - Adding **geospatial mapping** to analyze intake locations.  
  - Conducting **survival analysis** to study the time between intake and outcome.  

## **Installation**
To run this Shiny app locally, you need **R** (version 4.1+) and the required dependencies.

### **1. Clone the Repository**
```sh
git clone https://github.com/LBSO/lbso.git
cd lbso
```

### **2. Install Required Packages**
In **R**, install the necessary dependencies:
```r
install.packages(c("shiny", "shinydashboard", "ggplot2", "dplyr", "tidytuesdayR", "lubridate", "nnet"))
```

### **3. Run the App**
```r
shiny::runApp("app.R")
```

## **Usage**
1. Select a **date range** to filter records.
2. View intake statistics by **animal type** and **intake type**.
3. Enter **animal type, intake type, and sex** in the **prediction tab**.
4. Click **Predict Outcome** to get an AI-generated shelter outcome.

## **Machine Learning Model**
- **Model Type:** Multinomial Logistic Regression (`nnet` package)  
- **Features Used for Prediction:**  
  - `animal_type` (e.g., dog, cat, bird)  
  - `intake_type` (e.g., stray, owner surrender)  
  - `sex` (e.g., male, female)  
- **Predicted Outcome Categories:**  
  - **Adopted**  
  - **Transferred**  
  - **Returned to Owner**  
  - **Euthanized**  

## **Data Source**
- The dataset originates from the **Tidy Tuesday** project and includes **seven years of shelter data**.
- Source: [Tidy Tuesday Animal Shelter Dataset](https://github.com/rfordatascience/tidytuesday)

## **License**
This project is licensed under the **MIT License**. See the `LICENSE` file for details.

## **Contributing**
- We welcome contributions! If you'd like to add new features, improve performance, or refine the model:
- it is currently deployed on [shinyapp.io](https://148ab9f2967742b28e161684cd552d30.app.posit.cloud/)
---

