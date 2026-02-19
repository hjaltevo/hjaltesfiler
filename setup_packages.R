# Setup Script: Install Required R Packages
# This script installs all packages needed for the linear models interpretation tutorial

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org/"))

# List of required packages
required_packages <- c(
  "tidyverse",   # Data manipulation and visualization
  "broom",       # Tidy model outputs
  "effects",     # Effect plots
  "car",         # Regression diagnostics
  "coefplot",    # Coefficient plots
  "stargazer"    # Regression tables
)

# Function to install packages if not already installed
install_if_missing <- function(package) {
  if (!require(package, character.only = TRUE, quietly = TRUE)) {
    cat(sprintf("Installing %s...\n", package))
    install.packages(package, dependencies = TRUE)
  } else {
    cat(sprintf("%s is already installed.\n", package))
  }
}

# Install all required packages
cat("=== Installing Required Packages ===\n\n")
for (pkg in required_packages) {
  install_if_missing(pkg)
}

cat("\n=== Package Installation Complete ===\n")
cat("\nYou can now run the linear models interpretation script.\n")
