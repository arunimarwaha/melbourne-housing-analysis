# Melbourne Housing Market Analysis and Price Prediction

## Project Overview

This project analyzes Melbourne housing prices using data cleaning, exploratory analysis, regression modeling, outlier diagnostics, and classification techniques.

The goal is to understand how property characteristics and location are associated with housing prices, and to build models that can support real-estate pricing and buyer advisory decisions.

This project demonstrates a complete data analysis workflow: preparing raw data, exploring trends, building predictive models, evaluating results, and translating findings into business insights.

## Business Question

Can housing prices be predicted using property characteristics such as building area, suburb, car spaces, year built, and distance from the city center?

This project is framed as a real-estate analytics use case where statistical models are used to support pricing decisions, property screening, and market understanding.

## Dataset

The project uses the following dataset:

```text
data/Melbourne_housing_FULL.csv
```

The analysis focuses on three Melbourne suburbs:

* Brunswick
* Craigieburn
* Hawthorn

The final modeling dataset includes complete cases for the variables used in the analysis.

## Methods Used

* Data cleaning and missing value handling
* Exploratory Data Analysis
* Price and building area visualization
* Distance-to-CBD distribution analysis
* Simple and multiple linear regression
* Regression model comparison
* Cook’s Distance for influential observation detection
* Prediction intervals
* Logistic regression
* Linear Discriminant Analysis

## What the Project Does

The project first loads and cleans the Melbourne housing dataset, then filters the analysis to three selected suburbs to keep the results interpretable.

It explores housing price patterns using summary statistics and visualizations, including price distributions, building area distributions, and the relationship between building area and price.

The project then builds regression models to predict housing prices. It starts with a simple model using building area, then adds suburb and car spaces to evaluate whether location and property features improve model performance.

To make the analysis more reliable, the project checks for influential observations using Cook’s Distance. This is important because unusual property records can distort regression results and lead to misleading conclusions.

The project also creates a sample price prediction with a 95% prediction interval, showing how the model can estimate a realistic price range rather than only a single predicted value.

Finally, the project converts the pricing problem into a classification task by labeling properties as high-price or low-price. Logistic regression and Linear Discriminant Analysis are used to classify properties based on building area and year built.

## Outputs

Running the script saves all results in the `outputs/` folder.

### Figures

* Price distribution
* Building area distribution
* Price vs. building area by suburb
* Distance-to-CBD distribution plots
* Cook’s Distance plot
* Logistic regression decision boundary
* LDA decision boundary

### Tables

* Dataset overview
* Variable overview
* Cleaned modeling dataset
* Summary statistics
* Regression coefficients
* Regression model comparison
* Influential observation table
* Sample prediction interval
* Logistic regression results
* LDA summaries

## Repository Structure

```text
melbourne-housing-price-analysis/
│
├── data/
│   └── Melbourne_housing_FULL.csv
│
├── scripts/
│   └── melbourne_housing_analysis.R
│
├── outputs/
│   ├── figures/
│   └── tables/
│
└── README.md
```

## Tools and Packages Used

* R
* tidyverse
* ggplot2
* dplyr
* MASS
* broom

## How to Run the Project

1. Clone or download this repository.

2. Place the dataset in the `data/` folder:

```text
data/Melbourne_housing_FULL.csv
```

3. Open the project in RStudio or another R environment.

4. Run the script:

```r
source("scripts/melbourne_housing_analysis.R")
```

The script will generate all tables and figures automatically inside the `outputs/` folder.

## Key Insights

Building area is useful for predicting housing prices, but location also plays an important role.

Adding suburb and car spaces makes the regression model more informative for price prediction.

Cook’s Distance helps identify unusual properties that may strongly influence model results.

Prediction intervals are useful in a real-estate context because they provide a realistic price range rather than a single estimate.

Classification models such as logistic regression and LDA can support property screening by identifying high-price and low-price homes.

## Business Value

This project shows how data analysis can support real-estate decision-making.

The regression models help estimate how property features and suburb are associated with price. The prediction interval provides a practical way to communicate uncertainty around price estimates.

The classification models provide an alternative business use case by grouping properties into high-price and low-price segments. This could support buyer-facing tools, property screening, or market segmentation.

## Skills Demonstrated

This project demonstrates skills relevant to business analyst and data analyst roles, including:

* Cleaning and preparing real-world data
* Handling missing values
* Creating exploratory visualizations
* Building and comparing regression models
* Interpreting model outputs
* Detecting influential observations
* Creating prediction intervals
* Applying classification models
* Translating statistical results into business insights
* Building a reproducible analysis workflow in R

## Conclusion

This project demonstrates how housing data can be analyzed to understand price drivers and support pricing decisions.

By combining exploratory analysis, regression, outlier diagnostics, prediction intervals, and classification models, the project shows a practical end-to-end analytics workflow that is relevant for business and data analyst roles.
