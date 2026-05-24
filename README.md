# Regression Analysis of Salt Marsh Biomass — Linthurst Dataset

A reproducible statistical analysis identifying which physicochemical soil and
water properties most influence aboveground biomass production in a Cape Fear
Estuary salt marsh. The project applies ordinary least squares (OLS) regression,
collinearity diagnostics, Principal Component Regression (PCR), ridge regression,
and stepwise / best-subset model selection, then compares the methods on a common
set of fit and stability metrics.

> **Code sample for the Office of the New York State Attorney General — Research
> and Analytics Department, Data Analyst (Ref. No. RAD_NYC_DAT_6444).** A reviewer
> guide is provided in [`reviewer_guide.md`](reviewer_guide.md). New reviewers
> should start there.

---

## Overview

The full model fits the data well but is statistically unstable: with 14
predictors and only 45 observations, severe multicollinearity inflates the
standard errors and makes individual coefficients uninterpretable. The analysis
diagnoses that instability, then evaluates several remedies — dimensionality
reduction (PCR), regularization (ridge), and variable selection (stepwise,
best-subset) — and arrives at a small, interpretable model. It is a worked
example of moving from a noisy, over-parameterized fit to a defensible,
communicable result, with the limitations stated explicitly.

## Why it matters

Identifying the drivers of salt marsh productivity supports estuary conservation
and land-management decisions. Methodologically, the project addresses a problem
common to applied and policy analysis generally: how to draw reliable conclusions
when predictors are correlated and the sample is small. The emphasis is on
**reproducibility, honest diagnostics, and clear communication of uncertainty**
rather than on maximizing fit alone.

## Dataset

The **Linthurst dataset** describes a Cape Fear Estuary (North Carolina) salt
marsh. The unit of observation is a sampling site.

- **Observations:** 45
- **Response variable:** `BIO` — aboveground biomass
- **Predictors (full dataset, 14):** `H2S`, `SAL`, `Eh7`, `pH`, `BUF`, `P`, `K`,
  `Ca`, `Mg`, `Na`, `Mn`, `Zn`, `Cu`, `NH4` — soil/water chemistry measurements
  (e.g. salinity, acidity, and nutrient and trace-element concentrations)
- **Predictors (reduced dataset, 5):** `SAL`, `pH`, `K`, `Na`, `Zn` — a smaller
  candidate set used for the selection and regularization sections

Two source files are used: the full 14-predictor file (`LINTHALL.txt`) and the
reduced 5-predictor file (`LINTH-5.txt`). See **Repository structure** below for
where to place them.

## Analytical questions

1. Which physicochemical properties most strongly influence biomass production?
2. How severely does multicollinearity among the predictors affect the OLS
   estimates, and how can it be detected?
3. Do dimensionality reduction (PCR), regularization (ridge), and variable
   selection produce a more stable and interpretable model than full OLS?
4. What is the most parsimonious model that retains strong explanatory power?

## Methods used

- **Ordinary Least Squares (OLS)** — full 14-predictor baseline model.
- **Collinearity diagnostics** — Variance Inflation Factors (VIF), eigenvalue-based
  condition indices and condition number, and the predictor correlation matrix.
- **Principal Component Regression (PCR)** — predictors standardized, principal
  components retained to a 95% cumulative-variance threshold, regression fit on
  the retained components, and coefficients mapped back to the original variables.
- **Ridge regression** — L2 regularization with the penalty selected by
  cross-validation; ridge trace plotted to show coefficient shrinkage.
- **Stepwise selection** — combined forward/backward selection on the reduced
  dataset (entry and removal thresholds of 0.12).
- **Best-subset selection** — exhaustive search over predictor subsets ranked by
  BIC, with VIF used as a tie-breaker.
- **Residual diagnostics** — Residuals vs. Fitted, Normal Q-Q, Scale-Location,
  and Residuals vs. Leverage (Cook's distance).

**Tools:** Python — `pandas`, `numpy`, `statsmodels`, `scikit-learn`, `scipy`,
`matplotlib`.

## Repository structure

```
MATH564_Project/
├── README.md                                          # this file
├── reviewer_guide.md                                  # start here if reviewing
├── requirements.txt                                   # pinned dependencies
├── linthurst_sql_appendix.sql                         # supplementary SQL data-review queries
├── data/
│   ├── LINTHALL.txt                                   # full 14-predictor dataset  (add — see below)
│   └── LINTH-5.txt                                    # reduced 5-predictor dataset (add — see below)
├── MATH564 Final Project - A20536680 Mohammed Sahil.ipynb     # main analysis notebook
└── MATH564 Final Project Report- A20536680 Mohammed Sahil.pdf # full written report
```

> **Note on data files:** the notebook reads `data/LINTHALL.txt` and
> `data/LINTH-5.txt`. Place both files in the `data/` folder before running. The
> notebook's saved outputs already reflect a complete run, so the analysis can be
> reviewed in full without re-execution.

## Reproducibility instructions

```bash
# 1. Clone the repository
git clone https://github.com/Sahil-337/MATH564_Project.git
cd MATH564_Project

# 2. (Recommended) create and activate a virtual environment
python -m venv .venv
source .venv/bin/activate          # Windows: .venv\Scripts\activate

# 3. Install pinned dependencies
pip install -r requirements.txt

# 4. Ensure data/LINTHALL.txt and data/LINTH-5.txt are present, then launch
jupyter notebook "MATH564 Final Project - A20536680 Mohammed Sahil.ipynb"
```

Run the cells top to bottom. Versions in `requirements.txt` are pinned so the
notebook runs exactly as written; all results are deterministic.

## Key findings

*All figures below are taken directly from the notebook outputs.*

- **Full OLS model (14 predictors).** Strong overall fit — R-squared 0.807,
  adjusted R-squared 0.718, F-statistic 8.98 (p ≈ 3.1e-07) — but **no individual
  predictor is statistically significant** at conventional levels. This pattern (a
  significant model with no significant coefficients) is a classic symptom of
  multicollinearity.
- **Multicollinearity is severe.** Six predictors have VIF above 10 — `pH` (62.1),
  `Mg` (23.8), `BUF` (34.4), `Ca` (16.7), `Zn` (11.6), `Na` (10.4) — and the
  predictor correlation matrix shows `pH`–`BUF` correlated at 0.95 and `pH`–`Ca`
  at 0.88. The sum of coefficient standard errors in the full model is ≈ 4,048.
- **PCR stabilizes the estimates.** Retaining eight principal components (95%
  variance) yields R-squared 0.733 and cuts the summed standard errors from
  ≈ 4,048 to ≈ 513 — a substantial gain in coefficient stability — at the cost of
  a modest increase in sum of squared errors. This is the expected
  bias–variance trade-off.
- **Selection methods converge on a parsimonious model.** On the reduced dataset,
  stepwise selection and BIC-based best-subset selection **independently** identify
  the same two-variable model: `pH` and `Na`. That model has R-squared 0.658,
  adjusted R-squared 0.642, and both predictors significant (`pH` p < 0.001,
  `Na` p ≈ 0.01).
- **Overall.** `pH` is the dominant positive driver of biomass; a compact
  `pH` + `Na` model retains roughly two-thirds of the explanatory power of the
  full model while being far more stable and interpretable.

## Limitations

- **Small sample.** With 45 observations and 14 candidate predictors, the full
  model has limited residual degrees of freedom; estimates are sensitive and
  conclusions should be treated as exploratory.
- **Observational data.** The dataset is observational, so the findings describe
  association, not causation.
- **Selection-driven inference.** P-values from a model chosen by stepwise or
  best-subset search are optimistic; the selected `pH` + `Na` model would benefit
  from validation on independent data.
- **Single-site scope.** Results pertain to one estuary and may not generalize to
  other marsh systems.
- **Scope.** The project compares standard linear methods; non-linear models and
  formal out-of-sample cross-validation of the final model were out of scope.

## Relevance to the OAG Data Analyst role

This sample maps directly to the responsibilities in the posting:

- **Reproducible research with statistical and econometric techniques** — a fully
  documented regression workflow (OLS, PCR, ridge, model selection) with pinned
  dependencies and deterministic outputs.
- **Identifying limitations of sources and analysis** — multicollinearity is
  diagnosed explicitly, and the constraints of a small observational sample and of
  post-selection inference are stated rather than glossed over.
- **Synthesizing findings from data** — competing models are compared on a common
  set of metrics to reach a single, defensible conclusion.
- **Clear communication** — findings, methodology, and diagnostic visualizations
  are documented in both this repository and an accompanying written report for a
  reader who is not reproducing the code.

## Authorship

This is an individual academic project completed for **MATH 564 (Applied Statistics
/ Regression Analysis)** at the Illinois Institute of Technology. All code,
analysis, and writing are my own.

**Mohammed Sahil** · Portfolio: https://sahil-portfolio-three-omega.vercel.app/
