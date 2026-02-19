# Week 3: Linear Models Interpretation

This repository contains R code implementing linear models interpretation based on the tutorial from:
https://siljehermansen.github.io/teaching/beyond-linear-models/week3_linear_models_interpretation.html

## Dataset

The analysis uses the `MEP2014.rda` dataset, which contains information about Members of the European Parliament (MEPs) from 2014. The dataset includes:

- **LocalAssistants**: Number of local assistants employed by MEP
- **Age**: Age of the MEP in years
- **Female**: Binary indicator (1 = female, 0 = male)
- **Incumbent**: Binary indicator (1 = incumbent, 0 = new)
- **LaborCost**: Labor cost index
- **OpenList**: Electoral system indicator
- **cabinet_party**: Whether the MEP's party is in cabinet
- And other variables related to electoral systems and political context

## Files

### R Scripts

1. **`week3_linear_models_interpretation.R`** - Full version with tidyverse and additional packages
   - Requires: tidyverse, broom, effects, car, coefplot, stargazer
   - Most comprehensive with modern R practices
   - Best for learning and producing publication-ready output

2. **`week3_linear_models_base.R`** - Base R version (no dependencies)
   - Works with base R installation only
   - Ready to run immediately
   - Produces detailed console output with explanations
   - **Recommended for quick start**

3. **`setup_packages.R`** - Package installation script
   - Installs all required packages for the full version
   - Run this first if you want to use the tidyverse version

## Quick Start

### Option 1: Base R Version (Recommended)

This version requires no additional packages and runs immediately:

```r
# Load and run the base R script
source("week3_linear_models_base.R")
```

Or from command line:
```bash
Rscript week3_linear_models_base.R
```

### Option 2: Full Version with Packages

First install the required packages:

```r
# Install packages
source("setup_packages.R")

# Then run the full script
source("week3_linear_models_interpretation.R")
```

## Topics Covered

The scripts demonstrate the following linear modeling concepts:

### 1. **Data Exploration**
- Summary statistics
- Missing value analysis
- Variable distributions

### 2. **Simple Linear Regression**
- Single predictor models
- Coefficient interpretation
- Confidence intervals
- R-squared interpretation

### 3. **Multiple Linear Regression**
- Multiple predictors
- Partial effects / conditional effects
- Holding other variables constant
- Model comparison (F-test, AIC, BIC)

### 4. **Categorical Predictors**
- Binary variables (0/1)
- Reference category interpretation
- Group comparisons

### 5. **Interaction Effects**
- Interaction between continuous and categorical variables
- Interpreting interaction terms
- Visualizing interactions
- Different slopes for different groups

### 6. **Polynomial Terms**
- Non-linear relationships
- Quadratic models
- Interpreting curvature

### 7. **Model Diagnostics**
- Residual plots
- Normality checks (Q-Q plot)
- Homoscedasticity (constant variance)
- Outliers and influential observations
- Cook's distance
- Standardized residuals

### 8. **Predictions**
- Point predictions
- Confidence intervals (for means)
- Prediction intervals (for individuals)
- Difference between confidence and prediction intervals

### 9. **Standardized Coefficients**
- Comparing effect sizes across different scales
- Interpretation in standard deviation units
- Which variables have the strongest effects?

### 10. **Model Selection**
- Forward, backward, and stepwise selection
- AIC and BIC criteria
- Balancing fit and complexity

### 11. **Variable Transformations**
- Centering variables
- Log transformations for skewed data
- Interpreting coefficients with transformed variables

## Key Statistical Concepts

### Interpreting Coefficients

**Simple Regression (one predictor):**
- **Intercept**: Expected outcome when predictor = 0
- **Slope**: Change in outcome for 1-unit increase in predictor

**Multiple Regression:**
- Each coefficient is a **partial effect** - the effect of that predictor **holding all other predictors constant**
- Coefficients can change substantially when other variables are added

**Categorical Variables:**
- Coefficient represents the **difference** between the category and the reference group
- Example: Female coefficient = difference between female and male MEPs

**Interactions:**
- **Main effect**: Effect for the reference group
- **Interaction term**: How the effect differs for other groups
- Must interpret main effects and interactions together

**Polynomial Terms:**
- **Linear term**: Overall trend
- **Quadratic term**: Curvature (acceleration/deceleration)

### Model Fit Statistics

- **R-squared**: Proportion of variance explained (0-1)
- **Adjusted R-squared**: R-squared adjusted for number of predictors
- **F-statistic**: Overall model significance
- **AIC/BIC**: Model comparison metrics (lower is better)
- **Residual Standard Error**: Average prediction error

### Statistical Significance

- **p-value < 0.05**: Conventionally considered statistically significant
- **Confidence intervals**: Range of plausible values for coefficients
- **t-statistic**: Test of whether coefficient is significantly different from zero

## Model Diagnostics

Good regression models should satisfy:

1. **Linearity**: Relationship between predictors and outcome is linear
2. **Independence**: Observations are independent
3. **Normality**: Residuals are normally distributed
4. **Homoscedasticity**: Constant variance of residuals
5. **No multicollinearity**: Predictors are not highly correlated

Use diagnostic plots and tests to check these assumptions.

## Example Output

The base R script produces:
- Model summaries with coefficients and statistics
- Diagnostic plots for checking assumptions
- Predictions with confidence/prediction intervals
- Comparison of different model specifications
- Detailed interpretations of all key concepts

The full version additionally produces:
- Publication-ready plots with ggplot2
- Tidy model summaries with broom
- Effect plots with effects package
- Coefficient plots with coefplot
- Regression tables with stargazer

## Learning Objectives

After working through these scripts, you should be able to:

1. Fit and interpret simple and multiple linear regression models
2. Understand the difference between simple and partial effects
3. Work with categorical predictors and interpret group differences
4. Model and interpret interaction effects
5. Identify and model non-linear relationships
6. Check model assumptions using diagnostics
7. Make predictions with confidence and prediction intervals
8. Compare effect sizes using standardized coefficients
9. Select appropriate models using AIC/BIC
10. Transform variables appropriately (centering, logs)

## Requirements

### Base R Version
- R (version 3.6 or higher recommended)
- No additional packages required

### Full Version
- R (version 3.6 or higher)
- tidyverse
- broom
- effects
- car
- coefplot
- stargazer

## Installation

### Install R
- **Windows/Mac**: Download from https://cran.r-project.org/
- **Linux (Ubuntu/Debian)**: 
  ```bash
  sudo apt-get update
  sudo apt-get install r-base
  ```

### Install Required Packages (for full version)
```r
source("setup_packages.R")
```

Or manually:
```r
install.packages(c("tidyverse", "broom", "effects", "car", "coefplot", "stargazer"))
```

## Usage Tips

1. **Start with the base R version** to understand concepts without worrying about packages
2. **Read the inline comments** - they explain each step
3. **Examine the output carefully** - interpretation is provided throughout
4. **Try modifying the code** - change predictors, try different models
5. **Compare different models** - see how adding/removing variables changes results
6. **Pay attention to diagnostics** - they tell you if the model is appropriate

## Common Issues

**"Cannot load file MEP2014.rda"**
- Make sure you're in the correct working directory
- Use `setwd()` to set the correct directory, or
- Provide the full path to the .rda file

**"Package not found"**
- Run `setup_packages.R` to install missing packages
- Or use the base R version which has no dependencies

**"Object not found" errors**
- Make sure you've loaded the data with `load("MEP2014.rda")`
- Run the script from the beginning

## Additional Resources

- Original tutorial: https://siljehermansen.github.io/teaching/beyond-linear-models/week3_linear_models_interpretation.html
- R for Data Science: https://r4ds.had.co.nz/
- Introduction to Statistical Learning: https://www.statlearning.com/

## License

This code is provided for educational purposes. The MEP2014 dataset is used for demonstration purposes only.

## Author

Based on the tutorial by Silje Hermansen
Implementation for this repository: 2024
