# Length of Stay in Trauma Surgical ICU (TSICU) patients involved in Motor Vehicle Accidents

## Introduction

MIMIC is an open-access dataset developed by the MIT Lab for Computational Physiology which contains data for over 60,000 intensive care unit admissions at Beth Israel Deaconess Medical Center in Boston, MA [1](http://www.nature.com/articles/sdata201635). The dataset has wide-ranging applications in biostatistics, epidemiology, and computational medicine. In Homework 2, I noted that there was a noticeable spike in the age distribution of TSICU patients between the ages of 19-25, which I attributed to motor vehicle accidents. The TSICU serves patients with severe traumatic injury, respiratory failure as a consequence of major trauma, systemic organ failure, and critical illness post-surgery. [2](https://www.ccm.pitt.edu/content/upmc-presbyterian-surgical-trauma-icu).  In this analysis, I explore factors contributing to length of stay among TSICU patients who were involved in motor vehicle accidents. Data was manipulated through a PostgreSQL database and using R version 3.6.0 running on RStudio version 1.2.5033. Two types of analytic models were built: a linear regression model and a neural network regression model.

## Data preparation

Detailed data management and manipulation code can be found in [hw4a.Rmd][link here]. The following CONSORT flow diagram visually describes the process:

!(flowchart.png "CONSORT Flow Diagram")

---

## Visualization

Univariate and bivariate analyses for each predictor were performed to gauge model worthiness. The results are as follows:

### Univariate Analysis

!(dvars.png)

!(cvars.png)

### Bivariate Analysis

!(bv_disc.png)

!(bv_conts.png)

---

## Analytics

Results of model fitting are shown below:

### Linear Models

Two linear models were fit: a large model containing most relevant predictors, and a small model containing only predictors that were found to be statistically significant in the large model.

MODEL INFO:
Observations: 825 (406 missing obs. deleted)
Dependent Variable: hosp_time
Type: OLS linear regression 

MODEL FIT:
F(9,815) = 50.41, p = 0.00
R² = 0.36
Adj. R² = 0.35 

Standard errors: OLS
----------------------------------------------------------------------
                                           Est.   S.E.   t val.      p
--------------------------------------- ------- ------ -------- ------
(Intercept)                                1.83   1.12     1.64   0.10
seq_num                                    0.74   0.13     5.49   0.00
icu_los                                    1.08   0.06    17.76   0.00
factor(hospital_expire_flag)1             -6.31   1.79    -3.53   0.00
age                                        0.00   0.02     0.06   0.96
factor(gender)M                            0.17   0.62     0.28   0.78
relevel(as.factor(ts$ethnic_group),       -1.71   2.05    -0.83   0.40
ref = "WHITE")ASIAN                                                   
relevel(as.factor(ts$ethnic_group),        1.77   1.34     1.32   0.19
ref = "WHITE")BLACK                                                   
relevel(as.factor(ts$ethnic_group),        1.23   1.10     1.12   0.26
ref = "WHITE")HISPANIC                                                
factor(ever_married)TRUE                  -0.67   0.71    -0.95   0.34
----------------------------------------------------------------------

MODEL INFO:
Observations: 1231
Dependent Variable: hosp_time
Type: OLS linear regression 

MODEL FIT:
F(3,1227) = 271.21, p = 0.00
R² = 0.40
Adj. R² = 0.40 

Standard errors: OLS
------------------------------------------------------------------
                                       Est.   S.E.   t val.      p
----------------------------------- ------- ------ -------- ------
(Intercept)                            1.78   0.62     2.88   0.00
seq_num                                0.75   0.10     7.18   0.00
icu_los                                1.06   0.05    23.41   0.00
factor(hospital_expire_flag)1         -6.91   0.89    -7.80   0.00
------------------------------------------------------------------

### Neural Network Regression

A single hidden layer of 64 nodes was included in the neural network. Results are shown below:

!(nnr.png)

References

1. MIMIC-III, a freely accessible critical care database. Johnson AEW, Pollard TJ, Shen L, Lehman L, Feng M, Ghassemi M, Moody B, Szolovits P, Celi LA, and Mark RG. Scientific Data (2016). DOI: 10.1038/sdata.2016.35. Available from: http://www.nature.com/articles/sdata201635

2. https://www.ccm.pitt.edu/content/upmc-presbyterian-surgical-trauma-icu

