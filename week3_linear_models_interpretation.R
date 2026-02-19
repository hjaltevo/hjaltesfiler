# Week 3: Linear Models Interpretation
# Based on: https://siljehermansen.github.io/teaching/beyond-linear-models/week3_linear_models_interpretation.html
# Dataset: MEP2014 - Members of the European Parliament 2014

# Load required packages
library(tidyverse)  # For data manipulation and visualization
library(broom)      # For tidy model outputs
library(effects)    # For effect plots
library(car)        # For regression diagnostics

# Load the data
load("MEP2014.rda")

# ============================================================================
# 1. Data Exploration
# ============================================================================

# View the structure of the data
str(MEP2014)

# Summary statistics
summary(MEP2014)

# Check for missing values
colSums(is.na(MEP2014))

# Basic descriptive statistics for key variables
MEP2014 %>%
  select(LocalAssistants, Age, Female, Incumbent, LaborCost) %>%
  summary()

# ============================================================================
# 2. Simple Linear Regression
# ============================================================================

# Model 1: Predicting LocalAssistants from Age
model1 <- lm(LocalAssistants ~ Age, data = MEP2014)

# Model summary
summary(model1)

# Interpretation:
# - Intercept: Expected number of local assistants when Age = 0
# - Slope (Age): Change in local assistants for each additional year of age
# - R-squared: Proportion of variance explained by the model
# - p-value: Statistical significance of the relationship

# Extract coefficients
coef(model1)

# 95% Confidence intervals for coefficients
confint(model1)

# Tidy output using broom
tidy(model1)
glance(model1)

# Visualization
ggplot(MEP2014, aes(x = Age, y = LocalAssistants)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = TRUE, color = "blue") +
  labs(title = "Relationship between Age and Local Assistants",
       x = "Age (years)",
       y = "Number of Local Assistants") +
  theme_minimal()

# ============================================================================
# 3. Multiple Linear Regression
# ============================================================================

# Model 2: Multiple predictors
model2 <- lm(LocalAssistants ~ Age + Female + Incumbent + LaborCost, 
             data = MEP2014)

summary(model2)

# Interpretation of coefficients in multiple regression:
# - Each coefficient represents the change in the outcome for a one-unit
#   change in that predictor, holding all other predictors constant
# - This is the "partial effect" or "conditional effect"

# Compare models
anova(model1, model2)

# Model comparison statistics
AIC(model1, model2)
BIC(model1, model2)

# ============================================================================
# 4. Categorical Predictors
# ============================================================================

# Model 3: Including categorical variables
model3 <- lm(LocalAssistants ~ Age + Female + Incumbent + OpenList + 
             cabinet_party, data = MEP2014)

summary(model3)

# Interpretation of binary/categorical variables:
# - Female: Difference between female and male MEPs (reference category)
# - Incumbent: Difference between incumbent and non-incumbent MEPs
# - The coefficient represents the difference in the outcome between
#   the category (1) and the reference category (0)

# ============================================================================
# 5. Interactions
# ============================================================================

# Model 4: Interaction between Age and Female
model4 <- lm(LocalAssistants ~ Age * Female, data = MEP2014)

summary(model4)

# Interpretation of interactions:
# - Age: Effect of age for males (Female = 0, reference category)
# - Female: Difference between females and males when Age = 0
# - Age:Female: How the effect of Age differs for females vs males
#   (difference in slopes)

# Visualize the interaction
ggplot(MEP2014, aes(x = Age, y = LocalAssistants, color = factor(Female))) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(title = "Interaction between Age and Gender",
       x = "Age (years)",
       y = "Number of Local Assistants",
       color = "Gender") +
  scale_color_discrete(labels = c("Male", "Female")) +
  theme_minimal()

# Effect plots for interactions
plot(allEffects(model4))

# ============================================================================
# 6. Polynomial Terms (Non-linear relationships)
# ============================================================================

# Model 5: Quadratic relationship
model5 <- lm(LocalAssistants ~ Age + I(Age^2), data = MEP2014)

summary(model5)

# Interpretation of polynomial terms:
# - Age: Linear effect
# - I(Age^2): Quadratic effect (curvature)
# - A significant quadratic term suggests a non-linear relationship

# Visualize polynomial fit
ggplot(MEP2014, aes(x = Age, y = LocalAssistants)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", formula = y ~ x + I(x^2), 
              se = TRUE, color = "red") +
  labs(title = "Quadratic Relationship: Age and Local Assistants",
       x = "Age (years)",
       y = "Number of Local Assistants") +
  theme_minimal()

# Compare linear vs quadratic model
anova(model1, model5)

# ============================================================================
# 7. Model Diagnostics
# ============================================================================

# Diagnostic plots for model2
par(mfrow = c(2, 2))
plot(model2)
par(mfrow = c(1, 1))

# Key diagnostic plots:
# 1. Residuals vs Fitted: Check linearity assumption
# 2. Normal Q-Q: Check normality of residuals
# 3. Scale-Location: Check homoscedasticity (constant variance)
# 4. Residuals vs Leverage: Identify influential observations

# Additional diagnostics

# 1. Check for multicollinearity (VIF - Variance Inflation Factor)
vif(model2)
# VIF > 10 indicates problematic multicollinearity

# 2. Outliers and influential observations
# Cook's distance
cooks_d <- cooksplot(model2)

# Standardized residuals
std_resid <- rstandard(model2)
plot(std_resid, ylab = "Standardized Residuals", main = "Standardized Residuals Plot")
abline(h = c(-2, 0, 2), lty = 2, col = c("red", "black", "red"))

# 3. Durbin-Watson test for autocorrelation
durbinWatsonTest(model2)

# 4. Breusch-Pagan test for heteroscedasticity
ncvTest(model2)

# ============================================================================
# 8. Predictions and Fitted Values
# ============================================================================

# Get fitted values and residuals
augmented_data <- augment(model2)
head(augmented_data)

# Make predictions for new data
new_data <- data.frame(
  Age = c(40, 50, 60),
  Female = c(0, 1, 0),
  Incumbent = c(1, 1, 0),
  LaborCost = c(25, 30, 20)
)

# Point predictions
predictions <- predict(model2, newdata = new_data)
predictions

# Predictions with confidence intervals
predict(model2, newdata = new_data, interval = "confidence")

# Predictions with prediction intervals
predict(model2, newdata = new_data, interval = "prediction")

# ============================================================================
# 9. Standardized Coefficients
# ============================================================================

# Standardize variables for comparing effect sizes
MEP2014_std <- MEP2014 %>%
  mutate(across(c(Age, LaborCost, LocalAssistants), scale))

# Fit model with standardized variables
model_std <- lm(LocalAssistants ~ Age + Female + Incumbent + LaborCost, 
                data = MEP2014_std)

summary(model_std)

# Compare standardized coefficients
coef(model_std)

# Interpretation: 
# Standardized coefficients show the change in the outcome (in standard deviations)
# for a one standard deviation change in the predictor
# This allows comparison of effect sizes across predictors with different scales

# ============================================================================
# 10. Model Selection
# ============================================================================

# Full model
model_full <- lm(LocalAssistants ~ Age + Female + Incumbent + LaborCost + 
                 OpenList + NationalCandidateCentered + ProxNatElection +
                 cabinet_party + SeatsNatPal.prop, 
                 data = MEP2014)

summary(model_full)

# Backward selection using AIC
model_backward <- step(model_full, direction = "backward")

# Summary of selected model
summary(model_backward)

# Compare model performance
AIC(model2, model_full, model_backward)
BIC(model2, model_full, model_backward)

# ============================================================================
# 11. Presenting Results
# ============================================================================

# Create a nice coefficient plot
library(coefplot)

coefplot(model2, 
         title = "Coefficient Plot for Model 2",
         xlab = "Coefficient Estimate",
         ylab = "Variables",
         color = "blue")

# Create a regression table
library(stargazer)

stargazer(model1, model2, model3, 
          type = "text",
          title = "Regression Results",
          column.labels = c("Model 1", "Model 2", "Model 3"),
          dep.var.labels = "Number of Local Assistants",
          covariate.labels = c("Age", "Female", "Incumbent", 
                               "Labor Cost", "Open List", 
                               "Cabinet Party"),
          omit.stat = c("f", "ser"))

# ============================================================================
# 12. Additional Topics
# ============================================================================

# A. Centering variables
MEP2014_centered <- MEP2014 %>%
  mutate(Age_centered = Age - mean(Age, na.rm = TRUE),
         LaborCost_centered = LaborCost - mean(LaborCost, na.rm = TRUE))

# Model with centered variables
model_centered <- lm(LocalAssistants ~ Age_centered + Female + Incumbent + 
                    LaborCost_centered, data = MEP2014_centered)

summary(model_centered)

# Interpretation: 
# With centered variables, the intercept represents the expected value
# of the outcome when all continuous predictors are at their mean

# B. Interaction with centering
model_interaction_centered <- lm(LocalAssistants ~ Age_centered * Female, 
                                data = MEP2014_centered)

summary(model_interaction_centered)

# C. Log transformation for skewed variables
# Check distribution of LocalAssistants
hist(MEP2014$LocalAssistants, main = "Distribution of Local Assistants",
     xlab = "Number of Local Assistants", breaks = 20)

# Log transformation (add 1 to avoid log(0))
MEP2014$log_LocalAssistants <- log(MEP2014$LocalAssistants + 1)

model_log <- lm(log_LocalAssistants ~ Age + Female + Incumbent + LaborCost, 
                data = MEP2014)

summary(model_log)

# Interpretation with log-transformed outcome:
# Coefficients represent proportional changes
# e.g., a one-unit increase in Age is associated with a 
# 100 * (exp(coef) - 1)% change in LocalAssistants

# ============================================================================
# Summary of Key Concepts
# ============================================================================

cat("\n=============================================================\n")
cat("KEY CONCEPTS IN LINEAR MODEL INTERPRETATION:\n")
cat("=============================================================\n")
cat("1. Simple regression: One predictor, one outcome\n")
cat("2. Multiple regression: Multiple predictors, controlling for confounds\n")
cat("3. Categorical predictors: Interpreted as differences from reference\n")
cat("4. Interactions: Effects that depend on other variables\n")
cat("5. Polynomial terms: Non-linear relationships\n")
cat("6. Model diagnostics: Check assumptions (linearity, normality, etc.)\n")
cat("7. Predictions: Use model to predict new observations\n")
cat("8. Standardized coefficients: Compare effect sizes\n")
cat("9. Model selection: Choose best set of predictors\n")
cat("10. Variable transformations: Handle skewness, centering, etc.\n")
cat("=============================================================\n")
