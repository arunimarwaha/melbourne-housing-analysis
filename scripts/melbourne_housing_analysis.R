# Melbourne Housing Market Analysis and Price Prediction
# Author: Arunima Marwaha
#
# Purpose:
# This script analyzes Melbourne housing prices using EDA, regression,
# outlier diagnostics, prediction intervals, logistic regression, and LDA.
#
# Expected input:
# data/Melbourne_housing_FULL.csv
#
# Saved outputs:
# outputs/figures/
# outputs/tables/

# -----------------------------
# 1. Setup
# -----------------------------
required_packages <- c("tidyverse", "MASS", "broom")

for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

library(tidyverse)
library(MASS)
library(broom)

# Create output folders if they do not already exist
setwd("C:/Users/ama/OneDrive/OneDrive - ROCKWOOL FONDEN/Desktop/melbourne-housing-price-analysis")
dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

# -----------------------------
# 2. Load Data
# -----------------------------

input_file <- "data/Melbourne_housing_FULL.csv"

if (!file.exists(input_file)) {
  stop("Dataset not found. Please place Melbourne_housing_FULL.csv in the data/ folder.")
}

house <- read.csv(input_file, stringsAsFactors = FALSE)

# Save a basic dataset overview
dataset_overview <- data.frame(
  metric = c("Number of observations", "Number of variables"),
  value = c(nrow(house), ncol(house))
)

write.csv(dataset_overview,
          "outputs/tables/01_dataset_overview.csv",
          row.names = FALSE)

# Save variable names and classes
variable_overview <- data.frame(
  variable = names(house),
  class = sapply(house, class)
)

write.csv(variable_overview,
          "outputs/tables/02_variable_overview.csv",
          row.names = FALSE)

# -----------------------------
# 3. Data Cleaning and Subsetting
# -----------------------------

# Focus on three suburbs to keep the analysis interpretable
selected_suburbs <- c("Brunswick", "Craigieburn", "Hawthorn")

house_sub <- house %>%
  filter(Suburb %in% selected_suburbs) %>%
  mutate(
    Price = as.numeric(Price),
    BuildingArea = as.numeric(BuildingArea),
    Car = as.numeric(Car),
    YearBuilt = as.numeric(YearBuilt),
    Distance = as.numeric(Distance),
    Suburb = as.factor(Suburb)
  )

# Keep complete cases for variables used in the models
house_model <- house_sub %>%
  dplyr::select(Price, BuildingArea, Suburb, Car, YearBuilt, Distance) %>%
  tidyr::drop_na()

# Create high-price classification outcome
# 1 = high price, 0 = low price
house_model <- house_model %>%
  mutate(
    HighPrice = ifelse(Price >= 900000, 1, 0),
    HighPriceFactor = factor(HighPrice, levels = c(0, 1),
                             labels = c("Low price", "High price"))
  )

# Save cleaned modeling dataset
write.csv(house_model,
          "outputs/tables/03_cleaned_modeling_data.csv",
          row.names = FALSE)

# Save summary statistics
summary_stats <- house_model %>%
  summarise(
    observations = n(),
    avg_price = mean(Price),
    median_price = median(Price),
    min_price = min(Price),
    max_price = max(Price),
    avg_building_area = mean(BuildingArea),
    median_building_area = median(BuildingArea),
    avg_distance = mean(Distance),
    high_price_share = mean(HighPrice)
  )

write.csv(summary_stats,
          "outputs/tables/04_summary_statistics.csv",
          row.names = FALSE)

# -----------------------------
# 4. Exploratory Data Analysis
# -----------------------------

# Price distribution
p_price <- ggplot(house_model, aes(x = Price)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "white") +
  labs(
    title = "Distribution of Housing Prices",
    x = "Price (AUD)",
    y = "Number of properties"
  ) +
  theme_minimal()

ggsave("outputs/figures/01_price_distribution.png",
       p_price, width = 8, height = 5, dpi = 300)

# Building area distribution
p_area <- ggplot(house_model, aes(x = BuildingArea)) +
  geom_histogram(bins = 30, fill = "coral", color = "white") +
  labs(
    title = "Distribution of Building Area",
    x = "Building area (m2)",
    y = "Number of properties"
  ) +
  theme_minimal()

ggsave("outputs/figures/02_building_area_distribution.png",
       p_area, width = 8, height = 5, dpi = 300)

# Scatter plot: price vs building area
p_scatter <- ggplot(house_model, aes(x = BuildingArea, y = Price, color = Suburb)) +
  geom_point(alpha = 0.6) +
  labs(
    title = "Housing Price vs Building Area",
    x = "Building area (m2)",
    y = "Price (AUD)",
    color = "Suburb"
  ) +
  theme_minimal()

ggsave("outputs/figures/03_price_vs_building_area.png",
       p_scatter, width = 8, height = 5, dpi = 300)

# -----------------------------
# 5. Distance to CBD Density Analysis
# -----------------------------

distance_data <- house %>%
  mutate(Distance = as.numeric(Distance)) %>%
  filter(!is.na(Distance))

# Histogram: frequency
p_distance_freq <- ggplot(distance_data, aes(x = Distance)) +
  geom_histogram(bins = 30, fill = "grey70", color = "white") +
  labs(
    title = "Distance to CBD: Frequency Histogram",
    x = "Distance to CBD (km)",
    y = "Number of properties"
  ) +
  theme_minimal()

ggsave("outputs/figures/04_distance_frequency_histogram.png",
       p_distance_freq, width = 8, height = 5, dpi = 300)

# KDE with different kernel functions
distance_vector <- na.omit(distance_data$Distance)

kernels <- list(
  Gaussian = density(distance_vector, bw = 1, kernel = "gaussian"),
  Epanechnikov = density(distance_vector, bw = 1, kernel = "epanechnikov"),
  Triangular = density(distance_vector, bw = 1, kernel = "triangular"),
  Biweight = density(distance_vector, bw = 1, kernel = "biweight")
)

kernel_df <- bind_rows(lapply(names(kernels), function(k) {
  data.frame(
    Distance = kernels[[k]]$x,
    Density = kernels[[k]]$y,
    Kernel = k
  )
}))

p_kernel <- ggplot() +
  geom_histogram(data = distance_data, aes(x = Distance, y = after_stat(density)),
                 bins = 50, fill = "grey85", color = "white") +
  geom_line(data = kernel_df, aes(x = Distance, y = Density, color = Kernel),
            linewidth = 1) +
  labs(
    title = "Kernel Density Estimates of Distance to CBD",
    x = "Distance to CBD (km)",
    y = "Density",
    color = "Kernel"
  ) +
  theme_minimal()

ggsave("outputs/figures/05_kernel_density_comparison.png",
       p_kernel, width = 8, height = 5, dpi = 300)

# KDE with different bandwidths
bandwidths <- c(0.5, 1, 1.5)

bandwidth_df <- bind_rows(lapply(bandwidths, function(bw_value) {
  d <- density(distance_vector, bw = bw_value, kernel = "gaussian")
  data.frame(
    Distance = d$x,
    Density = d$y,
    Bandwidth = paste0("bw = ", bw_value)
  )
}))

p_bandwidth <- ggplot() +
  geom_histogram(data = distance_data, aes(x = Distance, y = after_stat(density)),
                 bins = 50, fill = "grey85", color = "white") +
  geom_line(data = bandwidth_df, aes(x = Distance, y = Density, color = Bandwidth),
            linewidth = 1) +
  labs(
    title = "Effect of Bandwidth on Gaussian KDE",
    x = "Distance to CBD (km)",
    y = "Density",
    color = "Bandwidth"
  ) +
  theme_minimal()

ggsave("outputs/figures/06_bandwidth_comparison.png",
       p_bandwidth, width = 8, height = 5, dpi = 300)

# Estimate probability of a property being 8-10km from CBD
optimal_bw <- bw.bcv(distance_vector, lower = 0.01, upper = 10)
density_optimal <- density(distance_vector, bw = optimal_bw, kernel = "gaussian")
density_function <- approxfun(density_optimal)
prob_8_10 <- integrate(density_function, 8, 10)$value

probability_table <- data.frame(
  metric = c("Optimal bandwidth", "Estimated probability between 8 and 10 km"),
  value = c(optimal_bw, prob_8_10)
)

write.csv(probability_table,
          "outputs/tables/05_distance_probability_8_10km.csv",
          row.names = FALSE)

p_density_optimal <- ggplot(data.frame(Distance = density_optimal$x,
                                       Density = density_optimal$y),
                            aes(x = Distance, y = Density)) +
  geom_line(linewidth = 1) +
  geom_vline(xintercept = c(8, 10), linetype = "dashed") +
  labs(
    title = "Estimated Distance Density with 8-10km Range",
    x = "Distance to CBD (km)",
    y = "Density"
  ) +
  theme_minimal()

ggsave("outputs/figures/07_distance_density_8_10km.png",
       p_density_optimal, width = 8, height = 5, dpi = 300)

# -----------------------------
# 6. Regression Models
# -----------------------------

# Simple model: building area only
fit_simple <- lm(Price ~ BuildingArea, data = house_model)

# Multiple model: building area and suburb
fit_multiple <- lm(Price ~ BuildingArea + Suburb, data = house_model)

# Extended model: building area, suburb and car spaces
fit_extended <- lm(Price ~ BuildingArea + Suburb + Car, data = house_model)

# Save regression outputs
write.csv(tidy(fit_simple),
          "outputs/tables/06_simple_regression_coefficients.csv",
          row.names = FALSE)

write.csv(tidy(fit_multiple),
          "outputs/tables/07_multiple_regression_coefficients.csv",
          row.names = FALSE)

write.csv(tidy(fit_extended),
          "outputs/tables/08_extended_regression_coefficients.csv",
          row.names = FALSE)

model_comparison <- bind_rows(
  glance(fit_simple) %>% mutate(model = "Simple: Price ~ BuildingArea"),
  glance(fit_multiple) %>% mutate(model = "Multiple: Price ~ BuildingArea + Suburb"),
  glance(fit_extended) %>% mutate(model = "Extended: Price ~ BuildingArea + Suburb + Car")
) %>%
  dplyr::select(model, r.squared, adj.r.squared, sigma, statistic, p.value, AIC, BIC)

write.csv(model_comparison,
          "outputs/tables/09_regression_model_comparison.csv",
          row.names = FALSE)

# -----------------------------
# 7. Outlier and Influence Analysis
# -----------------------------

cooks_d <- cooks.distance(fit_multiple)

outlier_table <- house_model %>%
  mutate(CooksD = cooks_d) %>%
  filter(BuildingArea <= 5 | BuildingArea > 300) %>%
  dplyr::select(Suburb, BuildingArea, Price, CooksD) %>%
  arrange(desc(CooksD))

write.csv(outlier_table,
          "outputs/tables/10_suspected_outliers_cooks_distance.csv",
          row.names = FALSE)

cooks_df <- data.frame(
  Observation = seq_along(cooks_d),
  CooksD = cooks_d
)

p_cooks <- ggplot(cooks_df, aes(x = Observation, y = CooksD)) +
  geom_col() +
  geom_hline(yintercept = 4 / nrow(house_model), linetype = "dashed") +
  labs(
    title = "Cook's Distance for Multiple Regression Model",
    x = "Observation",
    y = "Cook's Distance"
  ) +
  theme_minimal()

ggsave("outputs/figures/08_cooks_distance.png",
       p_cooks, width = 8, height = 5, dpi = 300)

# -----------------------------
# 8. Price Prediction Example
# -----------------------------

new_house <- data.frame(
  BuildingArea = 100,
  Suburb = factor("Hawthorn", levels = levels(house_model$Suburb)),
  Car = 2
)

prediction_interval <- as.data.frame(
  predict(fit_extended,
          newdata = new_house,
          interval = "prediction",
          level = 0.95)
)

prediction_output <- bind_cols(new_house, prediction_interval)

write.csv(prediction_output,
          "outputs/tables/11_hawthorn_sample_prediction_interval.csv",
          row.names = FALSE)

# -----------------------------
# 9. Classification Models
# -----------------------------

# Logistic regression model
logit_model <- glm(HighPrice ~ BuildingArea + YearBuilt,
                   data = house_model,
                   family = binomial)

write.csv(tidy(logit_model),
          "outputs/tables/12_logistic_regression_coefficients.csv",
          row.names = FALSE)

# Logistic regression decision boundary
logit_slope <- -coef(logit_model)[["BuildingArea"]] / coef(logit_model)[["YearBuilt"]]
logit_intercept <- -coef(logit_model)[["(Intercept)"]] / coef(logit_model)[["YearBuilt"]]

p_logit <- ggplot(house_model,
                  aes(x = BuildingArea, y = YearBuilt, color = HighPriceFactor)) +
  geom_point(alpha = 0.7) +
  geom_abline(slope = logit_slope, intercept = logit_intercept, linewidth = 1) +
  labs(
    title = "Logistic Regression Decision Boundary",
    x = "Building area (m2)",
    y = "Year built",
    color = "Price category"
  ) +
  theme_minimal()

ggsave("outputs/figures/09_logistic_regression_decision_boundary.png",
       p_logit, width = 8, height = 5, dpi = 300)

# LDA model
lda_model <- lda(HighPriceFactor ~ BuildingArea + YearBuilt, data = house_model)

# Save LDA prior probabilities and group means
lda_priors <- data.frame(class = names(lda_model$prior),
                         prior_probability = as.numeric(lda_model$prior))

write.csv(lda_priors,
          "outputs/tables/13_lda_prior_probabilities.csv",
          row.names = FALSE)

lda_means <- as.data.frame(lda_model$means)
lda_means$class <- rownames(lda_means)

write.csv(lda_means,
          "outputs/tables/14_lda_group_means.csv",
          row.names = FALSE)

# LDA decision boundary
w <- lda_model$scaling[, 1]
means <- lda_model$means
mid <- colMeans(means)

lda_slope <- -w[1] / w[2]
lda_intercept <- mid[2] - lda_slope * mid[1]

arrow_scale <- 0.6
x0 <- mid[1]
y0 <- mid[2]
x1 <- x0 + arrow_scale * w[1]
y1 <- y0 + arrow_scale * w[2]

p_lda <- ggplot(house_model,
                aes(x = BuildingArea, y = YearBuilt, color = HighPriceFactor)) +
  geom_point(alpha = 0.7) +
  geom_abline(slope = lda_slope, intercept = lda_intercept, linewidth = 1) +
  annotate("point", x = x0, y = y0, size = 3, color = "black") +
  annotate("segment",
           x = x0, y = y0, xend = x1, yend = y1,
           linewidth = 1,
           arrow = arrow(length = unit(0.25, "cm"))) +
  labs(
    title = "LDA Decision Boundary and Discriminant Direction",
    subtitle = "Line = decision boundary; arrow = LD1 direction",
    x = "Building area (m2)",
    y = "Year built",
    color = "Price category"
  ) +
  theme_minimal()

ggsave("outputs/figures/10_lda_decision_boundary.png",
       p_lda, width = 8, height = 5, dpi = 300)

# -----------------------------
# 10. Console Summary
# -----------------------------

cat("\nAnalysis complete.\n")
cat("Figures saved in: outputs/figures/\n")
cat("Tables saved in: outputs/tables/\n")
cat("\nEstimated probability of a house being 8-10km from CBD:",
    round(prob_8_10, 4), "\n")
cat("Sample Hawthorn prediction saved to outputs/tables/11_hawthorn_sample_prediction_interval.csv\n")
