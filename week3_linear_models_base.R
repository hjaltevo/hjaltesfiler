# Week 3: Linear Models Interpretation (Base R Version)
# Based on: https://siljehermansen.github.io/teaching/beyond-linear-models/week3_linear_models_interpretation.html
# Dataset: MEP2014 - Members of the European Parliament 2014

# This version uses only base R functions and is ready to run without additional packages

# Load the data
load("MEP2014.rda")

cat("=============================================================\n")
cat("Week 3: Linear Models Interpretation\n")
cat("=============================================================\n\n")

# ============================================================================
# 1. Data Exploration
# ============================================================================

cat("1. DATA EXPLORATION\n")
cat("-------------------\n")

# View the structure of the data
cat("\nData structure:\n")
str(MEP2014)

# Summary statistics
cat("\nSummary statistics:\n")
print(summary(MEP2014))

# Check for missing values
cat("\nMissing values by column:\n")
print(colSums(is.na(MEP2014)))

# ============================================================================
# 2. Simple Linear Regression
# ============================================================================

cat("\n\n=============================================================\n")
cat("2. SIMPLE LINEAR REGRESSION\n")
cat("-------------------\n")

# Model 1: Predicting LocalAssistants from Age
model1 <- lm(LocalAssistants ~ Age, data = MEP2014)

cat("\nModel 1: LocalAssistants ~ Age\n")
print(summary(model1))

cat("\nInterpretation of Model 1:\n")
cat("- Intercept:", coef(model1)[1], "\n")
cat("  Expected number of local assistants when Age = 0 (not meaningful in this context)\n")
cat("- Slope (Age):", coef(model1)[2], "\n")
cat("  For each additional year of age, the expected number of local assistants changes by", 
    round(coef(model1)[2], 4), "\n")
cat("- R-squared:", summary(model1)$r.squared, "\n")
cat("  Age explains", round(summary(model1)$r.squared * 100, 2), "% of the variance in local assistants\n")

# 95% Confidence intervals for coefficients
cat("\n95% Confidence Intervals:\n")
print(confint(model1))

# Visualization
cat("\nCreating scatter plot with regression line...\n")
plot(MEP2014$Age, MEP2014$LocalAssistants,
     main = "Relationship between Age and Local Assistants",
     xlab = "Age (years)",
     ylab = "Number of Local Assistants",
     pch = 16, col = rgb(0, 0, 1, 0.3))
abline(model1, col = "red", lwd = 2)
legend("topright", legend = "Regression line", col = "red", lwd = 2)

# ============================================================================
# 3. Multiple Linear Regression
# ============================================================================

cat("\n\n=============================================================\n")
cat("3. MULTIPLE LINEAR REGRESSION\n")
cat("-------------------\n")

# Model 2: Multiple predictors
model2 <- lm(LocalAssistants ~ Age + Female + Incumbent + LaborCost, 
             data = MEP2014)

cat("\nModel 2: LocalAssistants ~ Age + Female + Incumbent + LaborCost\n")
print(summary(model2))

cat("\nInterpretation of Multiple Regression Coefficients:\n")
cat("Each coefficient represents the change in the outcome for a one-unit\n")
cat("change in that predictor, HOLDING ALL OTHER PREDICTORS CONSTANT.\n")
cat("This is the 'partial effect' or 'conditional effect'.\n\n")

coefs <- coef(model2)
cat("- Age:", round(coefs["Age"], 4), "\n")
cat("  Holding other variables constant, each additional year is associated with\n")
cat("  a change of", round(coefs["Age"], 4), "local assistants\n\n")

cat("- Female:", round(coefs["Female"], 4), "\n")
cat("  Holding other variables constant, female MEPs have on average\n")
cat("  ", round(coefs["Female"], 4), "more/fewer local assistants than male MEPs\n\n")

cat("- Incumbent:", round(coefs["Incumbent"], 4), "\n")
cat("  Holding other variables constant, incumbent MEPs have on average\n")
cat("  ", round(coefs["Incumbent"], 4), "more/fewer local assistants than non-incumbents\n\n")

# Compare models
cat("\nComparing Model 1 vs Model 2:\n")
print(anova(model1, model2))

# Model comparison statistics
cat("\nModel Comparison - AIC (lower is better):\n")
cat("Model 1 AIC:", AIC(model1), "\n")
cat("Model 2 AIC:", AIC(model2), "\n")

cat("\nModel Comparison - BIC (lower is better):\n")
cat("Model 1 BIC:", BIC(model1), "\n")
cat("Model 2 BIC:", BIC(model2), "\n")

# ============================================================================
# 4. Categorical Predictors
# ============================================================================

cat("\n\n=============================================================\n")
cat("4. CATEGORICAL PREDICTORS\n")
cat("-------------------\n")

# Model 3: Including categorical variables
model3 <- lm(LocalAssistants ~ Age + Female + Incumbent + OpenList + 
             cabinet_party, data = MEP2014)

cat("\nModel 3: Including multiple categorical variables\n")
print(summary(model3))

cat("\nInterpretation of Binary/Categorical Variables:\n")
cat("For binary predictors (0/1), the coefficient represents the difference\n")
cat("in the outcome between the category coded as 1 and the reference category (0).\n\n")

coefs3 <- coef(model3)
cat("- Female (", round(coefs3["Female"], 4), "):\n")
cat("  Difference between female (1) and male (0) MEPs\n")
cat("- Incumbent (", round(coefs3["Incumbent"], 4), "):\n")
cat("  Difference between incumbent (1) and non-incumbent (0) MEPs\n")
cat("- OpenList (", round(coefs3["OpenList"], 4), "):\n")
cat("  Difference between open list (1) and closed list (0) systems\n")

# ============================================================================
# 5. Interactions
# ============================================================================

cat("\n\n=============================================================\n")
cat("5. INTERACTION EFFECTS\n")
cat("-------------------\n")

# Model 4: Interaction between Age and Female
model4 <- lm(LocalAssistants ~ Age * Female, data = MEP2014)

cat("\nModel 4: LocalAssistants ~ Age * Female (interaction model)\n")
print(summary(model4))

cat("\nInterpretation of Interaction Terms:\n")
coefs4 <- coef(model4)
cat("- Age (", round(coefs4["Age"], 4), "):\n")
cat("  Effect of age for the reference group (Males, Female=0)\n")
cat("- Female (", round(coefs4["Female"], 4), "):\n")
cat("  Difference between females and males when Age = 0\n")
cat("- Age:Female (", round(coefs4["Age:Female"], 4), "):\n")
cat("  How the effect of Age differs for females compared to males\n")
cat("  (the difference in slopes between the two groups)\n")

cat("\nEffective slopes:\n")
cat("- For Males: ", round(coefs4["Age"], 4), "\n")
cat("- For Females: ", round(coefs4["Age"] + coefs4["Age:Female"], 4), "\n")

# Visualize the interaction
cat("\nCreating interaction plot...\n")
plot(MEP2014$Age, MEP2014$LocalAssistants,
     col = ifelse(MEP2014$Female == 1, "red", "blue"),
     pch = 16,
     main = "Interaction between Age and Gender",
     xlab = "Age (years)",
     ylab = "Number of Local Assistants")

# Add separate regression lines for males and females
males <- MEP2014[MEP2014$Female == 0, ]
females <- MEP2014[MEP2014$Female == 1, ]
abline(lm(LocalAssistants ~ Age, data = males), col = "blue", lwd = 2)
abline(lm(LocalAssistants ~ Age, data = females), col = "red", lwd = 2)
legend("topright", legend = c("Male", "Female"), 
       col = c("blue", "red"), pch = 16, lwd = 2)

# ============================================================================
# 6. Polynomial Terms (Non-linear relationships)
# ============================================================================

cat("\n\n=============================================================\n")
cat("6. POLYNOMIAL TERMS (NON-LINEAR RELATIONSHIPS)\n")
cat("-------------------\n")

# Model 5: Quadratic relationship
model5 <- lm(LocalAssistants ~ Age + I(Age^2), data = MEP2014)

cat("\nModel 5: LocalAssistants ~ Age + Age² (quadratic model)\n")
print(summary(model5))

cat("\nInterpretation of Polynomial Terms:\n")
cat("- Age: Linear effect of age\n")
cat("- Age²: Quadratic effect (curvature)\n")
cat("A significant quadratic term indicates a non-linear relationship\n")
cat("where the effect of Age changes as Age increases.\n")

# Compare linear vs quadratic model
cat("\nComparing linear vs quadratic model:\n")
print(anova(model1, model5))

# Visualize polynomial fit
cat("\nCreating polynomial fit plot...\n")
plot(MEP2014$Age, MEP2014$LocalAssistants,
     main = "Linear vs Quadratic Fit",
     xlab = "Age (years)",
     ylab = "Number of Local Assistants",
     pch = 16, col = rgb(0, 0, 0, 0.3))

# Add linear fit
abline(model1, col = "blue", lwd = 2)

# Add quadratic fit
age_seq <- seq(min(MEP2014$Age, na.rm = TRUE), 
               max(MEP2014$Age, na.rm = TRUE), length.out = 100)
pred_quad <- predict(model5, newdata = data.frame(Age = age_seq))
lines(age_seq, pred_quad, col = "red", lwd = 2)

legend("topright", legend = c("Linear", "Quadratic"), 
       col = c("blue", "red"), lwd = 2)

# ============================================================================
# 7. Model Diagnostics
# ============================================================================

cat("\n\n=============================================================\n")
cat("7. MODEL DIAGNOSTICS\n")
cat("-------------------\n")

cat("\nCreating diagnostic plots for Model 2...\n")
par(mfrow = c(2, 2))
plot(model2)
par(mfrow = c(1, 1))

cat("\nKey Diagnostic Plots:\n")
cat("1. Residuals vs Fitted: Check for linearity and homoscedasticity\n")
cat("   - Points should be randomly scattered around horizontal line at 0\n")
cat("2. Normal Q-Q: Check normality of residuals\n")
cat("   - Points should follow the diagonal line\n")
cat("3. Scale-Location: Check homoscedasticity (constant variance)\n")
cat("   - Points should be randomly scattered with constant spread\n")
cat("4. Residuals vs Leverage: Identify influential observations\n")
cat("   - Points outside Cook's distance lines are influential\n")

# Additional diagnostics
cat("\nAdditional Diagnostic Tests:\n")

# Standardized residuals
std_resid <- rstandard(model2)
cat("\nStandardized Residuals Summary:\n")
print(summary(std_resid))
cat("Points with |standardized residual| > 2 are potential outliers\n")
outliers <- which(abs(std_resid) > 2)
cat("Number of potential outliers:", length(outliers), "\n")

# Cook's distance
cooks_d <- cooks.distance(model2)
cat("\nCook's Distance Summary:\n")
print(summary(cooks_d))
influential <- which(cooks_d > 4/nrow(MEP2014))
cat("Number of influential observations (Cook's D > 4/n):", length(influential), "\n")

# ============================================================================
# 8. Predictions and Fitted Values
# ============================================================================

cat("\n\n=============================================================\n")
cat("8. PREDICTIONS\n")
cat("-------------------\n")

# Make predictions for new data
new_data <- data.frame(
  Age = c(40, 50, 60),
  Female = c(0, 1, 0),
  Incumbent = c(1, 1, 0),
  LaborCost = c(25, 30, 20)
)

cat("\nNew data for predictions:\n")
print(new_data)

# Point predictions
predictions <- predict(model2, newdata = new_data)
cat("\nPoint Predictions:\n")
print(predictions)

# Predictions with confidence intervals (for the mean)
pred_conf <- predict(model2, newdata = new_data, interval = "confidence")
cat("\nPredictions with 95% Confidence Intervals (for the mean):\n")
print(pred_conf)

# Predictions with prediction intervals (for individual observations)
pred_pred <- predict(model2, newdata = new_data, interval = "prediction")
cat("\nPredictions with 95% Prediction Intervals (for new observations):\n")
print(pred_pred)

cat("\nNote: Prediction intervals are wider than confidence intervals\n")
cat("because they account for both parameter uncertainty and individual variation.\n")

# ============================================================================
# 9. Standardized Coefficients
# ============================================================================

cat("\n\n=============================================================\n")
cat("9. STANDARDIZED COEFFICIENTS\n")
cat("-------------------\n")

# Standardize variables for comparing effect sizes
MEP2014_std <- MEP2014
MEP2014_std$Age_std <- scale(MEP2014$Age)
MEP2014_std$LaborCost_std <- scale(MEP2014$LaborCost)
MEP2014_std$LocalAssistants_std <- scale(MEP2014$LocalAssistants)

# Fit model with standardized variables
model_std <- lm(LocalAssistants_std ~ Age_std + Female + Incumbent + LaborCost_std, 
                data = MEP2014_std)

cat("\nModel with Standardized Variables:\n")
print(summary(model_std))

cat("\nComparison of Standardized Coefficients:\n")
coefs_std <- coef(model_std)[-1]  # Exclude intercept
print(sort(abs(coefs_std), decreasing = TRUE))

cat("\nInterpretation:\n")
cat("Standardized coefficients show the change in the outcome (in standard deviations)\n")
cat("for a one standard deviation change in the predictor.\n")
cat("This allows comparison of effect sizes across predictors with different scales.\n")
cat("Variables with larger |standardized coefficient| have stronger effects.\n")

# ============================================================================
# 10. Model Selection
# ============================================================================

cat("\n\n=============================================================\n")
cat("10. MODEL SELECTION\n")
cat("-------------------\n")

# Full model with many predictors
model_full <- lm(LocalAssistants ~ Age + Female + Incumbent + LaborCost + 
                 OpenList + NationalCandidateCentered + ProxNatElection +
                 cabinet_party + SeatsNatPal.prop, 
                 data = MEP2014)

cat("\nFull Model Summary:\n")
print(summary(model_full))

# Backward selection using AIC
cat("\nPerforming backward selection based on AIC...\n")
model_backward <- step(model_full, direction = "backward", trace = 0)

cat("\nBackward Selection Results:\n")
print(summary(model_backward))

cat("\nFinal model formula from backward selection:\n")
print(formula(model_backward))

# Compare model performance
cat("\nModel Comparison - AIC (lower is better):\n")
models_aic <- data.frame(
  Model = c("Model 2", "Full Model", "Backward Selection"),
  AIC = c(AIC(model2), AIC(model_full), AIC(model_backward))
)
print(models_aic)

cat("\nModel Comparison - BIC (lower is better):\n")
models_bic <- data.frame(
  Model = c("Model 2", "Full Model", "Backward Selection"),
  BIC = c(BIC(model2), BIC(model_full), BIC(model_backward))
)
print(models_bic)

# ============================================================================
# 11. Variable Transformations
# ============================================================================

cat("\n\n=============================================================\n")
cat("11. VARIABLE TRANSFORMATIONS\n")
cat("-------------------\n")

# A. Centering variables
cat("\nA. CENTERING VARIABLES\n")
MEP2014_centered <- MEP2014
MEP2014_centered$Age_centered <- MEP2014$Age - mean(MEP2014$Age, na.rm = TRUE)
MEP2014_centered$LaborCost_centered <- MEP2014$LaborCost - mean(MEP2014$LaborCost, na.rm = TRUE)

# Model with centered variables
model_centered <- lm(LocalAssistants ~ Age_centered + Female + Incumbent + 
                    LaborCost_centered, data = MEP2014_centered)

cat("\nModel with Centered Variables:\n")
print(summary(model_centered))

cat("\nNote: With centered variables, the intercept represents the expected value\n")
cat("of the outcome when all continuous predictors are at their mean values.\n")
cat("Intercept =", coef(model_centered)[1], "\n")
cat("This is the expected number of local assistants for a person with\n")
cat("average age (", round(mean(MEP2014$Age, na.rm = TRUE), 2), " years) and\n")
cat("average labor cost (", round(mean(MEP2014$LaborCost, na.rm = TRUE), 2), ").\n")

# B. Log transformation for skewed variables
cat("\n\nB. LOG TRANSFORMATION\n")
cat("Checking distribution of LocalAssistants...\n")
hist(MEP2014$LocalAssistants, 
     main = "Distribution of Local Assistants",
     xlab = "Number of Local Assistants", 
     breaks = 20,
     col = "lightblue")

cat("\nThe distribution is right-skewed. Let's try log transformation.\n")

# Log transformation (add 1 to avoid log(0))
MEP2014$log_LocalAssistants <- log(MEP2014$LocalAssistants + 1)

cat("\nDistribution after log transformation:\n")
hist(MEP2014$log_LocalAssistants,
     main = "Distribution of log(Local Assistants + 1)",
     xlab = "log(Number of Local Assistants + 1)",
     breaks = 20,
     col = "lightgreen")

model_log <- lm(log_LocalAssistants ~ Age + Female + Incumbent + LaborCost, 
                data = MEP2014)

cat("\nModel with Log-Transformed Outcome:\n")
print(summary(model_log))

cat("\nInterpretation with log-transformed outcome:\n")
cat("Coefficients represent proportional changes.\n")
cat("For small coefficients, approximately:\n")
cat("A one-unit increase in the predictor is associated with a\n")
cat("(coefficient × 100)% change in the outcome.\n\n")

coefs_log <- coef(model_log)
cat("Example: Age coefficient =", round(coefs_log["Age"], 4), "\n")
cat("Each additional year of age is associated with approximately a\n")
cat(round(coefs_log["Age"] * 100, 2), "% change in the number of local assistants.\n")

# ============================================================================
# Summary
# ============================================================================

cat("\n\n=============================================================\n")
cat("SUMMARY: KEY CONCEPTS IN LINEAR MODEL INTERPRETATION\n")
cat("=============================================================\n\n")

cat("1. SIMPLE REGRESSION\n")
cat("   - One predictor, one outcome\n")
cat("   - Intercept + Slope interpretation\n")
cat("   - R² shows proportion of variance explained\n\n")

cat("2. MULTIPLE REGRESSION\n")
cat("   - Multiple predictors control for confounds\n")
cat("   - Coefficients are 'partial effects' holding others constant\n")
cat("   - Use model comparison (AIC, BIC, F-test) to evaluate models\n\n")

cat("3. CATEGORICAL PREDICTORS\n")
cat("   - Binary variables: difference from reference category\n")
cat("   - Coefficient is the mean difference between groups\n\n")

cat("4. INTERACTIONS\n")
cat("   - Effects that depend on other variables\n")
cat("   - Interaction term shows how one effect varies across groups\n")
cat("   - Must interpret main effects and interaction together\n\n")

cat("5. POLYNOMIAL TERMS\n")
cat("   - Model non-linear relationships (curves)\n")
cat("   - Quadratic: Age + Age²\n")
cat("   - Significant quadratic term indicates curvature\n\n")

cat("6. MODEL DIAGNOSTICS\n")
cat("   - Check assumptions: linearity, normality, homoscedasticity\n")
cat("   - Look for outliers and influential observations\n")
cat("   - Use diagnostic plots and statistical tests\n\n")

cat("7. PREDICTIONS\n")
cat("   - Use model to predict new observations\n")
cat("   - Confidence intervals: uncertainty about the mean\n")
cat("   - Prediction intervals: uncertainty for individual observations\n\n")

cat("8. STANDARDIZED COEFFICIENTS\n")
cat("   - Allow comparison of effect sizes across different scales\n")
cat("   - Show change in SD of outcome per SD change in predictor\n\n")

cat("9. MODEL SELECTION\n")
cat("   - Choose best set of predictors\n")
cat("   - Balance fit and complexity (AIC, BIC)\n")
cat("   - Stepwise selection can help automate\n\n")

cat("10. VARIABLE TRANSFORMATIONS\n")
cat("    - Centering: makes intercept interpretable\n")
cat("    - Log: handles skewness, models proportional change\n")
cat("    - Standardizing: enables effect size comparison\n\n")

cat("=============================================================\n")
cat("Tutorial complete!\n")
cat("=============================================================\n")
