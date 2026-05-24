# Reviewer Guide

*Prepared for reviewers at the Office of the New York State Attorney General —
Research and Analytics Department (Data Analyst, Ref. No. RAD_NYC_DAT_6444).*

This repository is submitted as a **code sample in lieu of a writing sample**. It
is designed to be evaluated in about 3–5 minutes. This guide points you to what
matters and why it is relevant to the role.

---

## What to open first

1. **`README.md`** — one-page orientation: the problem, dataset, methods, key
   findings, and stated limitations.
2. **`MATH564 Final Project - A20536680 Mohammed Sahil.ipynb`** — the main
   analysis notebook. All cells have saved outputs, so the full analysis can be
   read end-to-end **without re-running anything**.
3. **`MATH564 Final Project Report- A20536680 Mohammed Sahil.pdf`** — the
   accompanying written report, for the narrative and interpretation in prose.

If you have only a few minutes: read the README, then skim the notebook from top
to bottom — the markdown cells introduce each section before its code and output.

## What the notebook demonstrates

The notebook analyzes the Linthurst salt marsh dataset (45 observations, 14
candidate predictors) to identify the drivers of biomass production. In order, it:

1. **Fits a full OLS regression** and reports fit statistics and coefficients.
2. **Diagnoses multicollinearity** with VIF, eigenvalue-based condition indices,
   and the correlation matrix — showing that a well-fitting model can still have
   unstable, uninterpretable coefficients.
3. **Applies Principal Component Regression** to reduce dimensionality, and shows
   the gain in coefficient stability (summed standard errors fall from ≈ 4,048 to
   ≈ 513) against a modest fit trade-off.
4. **Applies ridge regression** with a cross-validated penalty, including a ridge
   trace plot.
5. **Runs stepwise and best-subset (BIC) selection**, which independently converge
   on the same parsimonious two-variable model (`pH` + `Na`).
6. **Produces residual diagnostic plots** to check the regression assumptions.

It demonstrates: a complete, reproducible statistical workflow; correct use of
econometric diagnostics; comparison of competing models on common metrics; and
explicit, honest treatment of the analysis's limitations.

A supplementary **`linthurst_sql_appendix.sql`** is also included — see note below.

## Where the written report is

The full written report is the PDF in the repository root:
**`MATH564 Final Project Report- A20536680 Mohammed Sahil.pdf`**. It presents the
methodology, results, and interpretation in narrative form for a reader who is not
executing the code.

## About the SQL appendix

`linthurst_sql_appendix.sql` is a **supplementary file**, not part of the original
academic analysis. It demonstrates SQL-style data review on the same dataset —
table definition, null/data-quality checks, summary statistics, and
filtering/grouping queries. It is included to show SQL fluency alongside the
Python analysis and is clearly labelled as an appendix throughout.

## Why this sample is relevant to the role

The position emphasizes reproducible research, statistical and econometric
technique, identifying the limitations of an analysis, and clear communication in
support of investigations and policy work. This sample shows each of those
directly:

- a documented, deterministic workflow with pinned dependencies;
- correct application of regression, regularization, dimensionality reduction, and
  model-selection methods;
- multicollinearity diagnosed and the constraints of a small observational sample
  stated plainly rather than omitted;
- findings communicated for both a technical reader (notebook) and a
  non-reproducing reader (written report and README).

## Authorship

Individual academic project for MATH 564 (Regression Analysis), Illinois Institute
of Technology. All code, analysis, and writing are the candidate's own. It was not
produced for or affiliated with the OAG.
