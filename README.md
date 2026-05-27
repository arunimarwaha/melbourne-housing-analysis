# Melbourne Housing Market Analysis and Price Prediction

## Project Overview

This project analyzes residential housing prices in Melbourne using exploratory data analysis, regression modeling, outlier diagnostics, and classification techniques.

The goal is to understand how property characteristics and location are associated with housing prices, and to compare different statistical approaches for predicting and classifying property values.

## Business Question

Can housing prices be predicted using property characteristics such as building area, suburb, car spaces, year built, and distance from the city center?

This project is framed as a real-estate analytics use case where statistical models are used to support pricing decisions and buyer advisory insights.

## Dataset

The project uses the `data/Melbourne_housing_FULL.csv` dataset.

## Methods Used

- Exploratory Data Analysis
- Data cleaning and missing value handling
- Histogram and density visualization
- Kernel Density Estimation
- Linear Regression
- Multiple Linear Regression
- Cook's Distance for influential observation detection
- Prediction intervals
- Logistic Regression
- Linear Discriminant Analysis

## Key Questions

- How are housing prices distributed across selected Melbourne suburbs?
- Is building area a useful predictor of price?
- Does including suburb improve price prediction?
- Are extreme building-area observations influential?
- Can properties be classified into high-price and low-price categories?
- Which model is more useful for supporting buyer-facing decisions?

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
├── README.md
```

## Outputs

Running the R script saves:

### Figures
- Price and building area distributions
- Price vs. building area scatter plot
- Distance-to-CBD density plots
- Logistic regression decision boundary
- LDA decision boundary

### Tables
- Dataset overview
- Summary statistics
- Regression summaries
- Cook's Distance outlier table
- Prediction interval for a sample property
- Classification model summaries

## Tools Used

- R
- ggplot2
- dplyr
- MASS
- broom

## How to Run

1. Download or clone this repository.
2. Open R or RStudio.
3. Run:

```r
source("scripts/melbourne_housing_analysis.R")
```

The script will create saved figures and tables inside the `outputs/` folder.

## Portfolio Relevance

This project demonstrates practical data analyst skills: cleaning real-world data, conducting exploratory analysis, building regression and classification models, evaluating outliers, and translating model results into business-relevant insights.
