# MATH564_Project
Analysis of Linthurst Data
Final Project 2024: Regression Analysis on Linthurst Data
Project Description
This project analyzes the Linthurst dataset to identify the physicochemical properties influencing biomass production in the Cape Fear Estuary. The project includes:

Ordinary Least Squares (OLS) Regression.
Collinearity Diagnostics.
Principal Component Regression (PCR).
Stepwise Regression for a reduced dataset.
Ridge Regression and Subset Selection.
Files Included
Math Final Project - Regression Final.ipynb:
Contains all code for the analysis, from data loading to regression diagnostics and model selection.
project2024.pdf:
The project description and requirements.
README.md:
Documentation and instructions for running the project.
Steps to Run the Project
Prerequisites:
Install Python (3.7 or later).
Install the required Python libraries:
bash
Copy code
pip install pandas numpy statsmodels matplotlib seaborn scikit-learn
Execution:
Open the Jupyter notebook file: Math Final Project - Regression Final.ipynb.
Run each cell sequentially to reproduce the analysis and results.
Project Workflow
1. Data Loading and Preprocessing
Load the Linthurst dataset and preprocess to exclude unused columns.
2. Ordinary Least Squares (OLS) Regression
Fit an OLS model using the full dataset.
Report regression coefficients, standard errors, and Sum of Squared Errors (SSE).
Generate diagnostic plots.
3. Collinearity Diagnostics
Assess multicollinearity using Variance Inflation Factor (VIF), condition number, and correlation matrix.
4. Principal Component Regression (PCR)
Reduce collinearity by selecting principal components.
Compare performance metrics with the OLS model.
5. Stepwise Regression
Perform forward and backward selection on the reduced 5-predictor dataset.
6. Ridge Regression
Use ridge regression to address multicollinearity.
Generate ridge trace plots for variable selection.
7. Subset Selection
Identify the best two-variable model based on AIC, BIC, and SSE.
Results
Outputs include regression coefficients, diagnostics, and selected models.
Diagnostic plots are provided for all regression methods.
