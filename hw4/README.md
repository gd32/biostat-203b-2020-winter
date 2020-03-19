# Length of Stay in Trauma Surgical ICU (TSICU) patients involved in Motor Vehicle Accidents

## Introduction

MIMIC is an open-access dataset developed by the MIT Lab for Computational Physiology which contains data for over 60,000 intensive care unit admissions at Beth Israel Deaconess Medical Center in Boston, MA <sup>[1](http://www.nature.com/articles/sdata201635)</sup> The dataset has wide-ranging applications in biostatistics, epidemiology, and computational medicine. In Homework 2, I noted that there was a noticeable spike in the age distribution of TSICU patients between the ages of 19-25, which I attributed to motor vehicle accidents. The TSICU serves patients with severe traumatic injury, respiratory failure as a consequence of major trauma, systemic organ failure, and critical illness post-surgery. <sup>[2](https://www.ccm.pitt.edu/content/upmc-presbyterian-surgical-trauma-icu)</sup>  In this analysis, I explore factors contributing to length of stay among TSICU patients who were involved in motor vehicle accidents. Data was manipulated through a PostgreSQL database and using R version 3.6.0 running on RStudio version 1.2.5033. Two types of analytic models were built: a linear regression model and a neural network regression model.

## Data preparation

Detailed data management and manipulation code can be found in [hw4a.Rmd](https://github.com/gd32/biostat-203b-2020-winter/blob/master/hw4/hw4a.Rmd). The following CONSORT flow diagram visually describes the process:

![Flowchart](https://github.com/gd32/biostat-203b-2020-winter/blob/develop/hw4/images/flowchart.png)

---

## Visualization

Univariate and bivariate analyses for each predictor were performed to gauge model worthiness. The results are as follows:

### Univariate Analysis

A majority of patients survived their time in the TSICU; over 60% were male, 35% were ever married, and over 60% were white. The diagnosis priority for the motor vehicle accident leading to the ICU stay on average was between 4 to 6. The age distribution heavily favored individuals between 15 to 30 years old. In regards to length of ICU stay and time spent in the emergency room, both distributions were heavily skewed. Median length of ICU stay was less than 3 days and the median time in the emergency room was about 2.5 hours.

![Discrete variables](https://github.com/gd32/biostat-203b-2020-winter/blob/develop/hw4/images/dvars.png)

![Continuous variables](https://github.com/gd32/biostat-203b-2020-winter/blob/develop/hw4/images/cvars.png)

### Bivariate Analysis

Bivariate analysis showed a noticeable difference in length of stay between those who survived their ICU stay and those who died as well as in different groups of diagnosis priority; there was little correlation between the other chosen predictors.

![Bivariate discrete](https://github.com/gd32/biostat-203b-2020-winter/blob/develop/hw4/images/bv_disc.png)

![Bivariate continuous](https://github.com/gd32/biostat-203b-2020-winter/blob/develop/hw4/images/bv_conts.png)

---

## Analytics

Results of model fitting are shown below:

### Linear Models

Two linear models were fit: a large model containing most relevant predictors, and a small model containing only predictors that were found to be statistically significant in the large model.

![Large model](https://github.com/gd32/biostat-203b-2020-winter/blob/master/hw4/images/lm_longer.png)

![Small model](https://github.com/gd32/biostat-203b-2020-winter/blob/master/hw4/images/lm_shorter.png)

### Neural Network Regression

A single hidden layer of 64 nodes was included in the neural network. Results are shown below:

![Neural net](https://github.com/gd32/biostat-203b-2020-winter/blob/develop/hw4/images/nnr.png)

The neural network regression performed slightly better than the reduced linear model. While the performance gain was minimal, it is possible that increasing the number of hidden layers would improve model performance.

## Conclusion

Neither model type performed optimally; however, we saw that the primary factors affecting length of stay among our chosen covariates were diagnosis priority, length of ICU stay, and survival status. It makes sense that patients who have potential to recover would remain in the hospital longer for rehabilitation or preventive measures; those who are at higher risk of death have much shorter stays (likely to due to increased severity of traumatic injury). Further optimization of the models is warranted, as inclusion of specific injury types that are associated with TSICU admission as well as with severity of injury could drastically affect performance. For example, patients with broken bones or similar injury could have noticeably different length of stay when compared to those with soft tissue or head injury.

## References

1. MIMIC-III, a freely accessible critical care database. Johnson AEW, Pollard TJ, Shen L, Lehman L, Feng M, Ghassemi M, Moody B, Szolovits P, Celi LA, and Mark RG. Scientific Data (2016). DOI: 10.1038/sdata.2016.35. Available from: http://www.nature.com/articles/sdata201635

2. https://www.ccm.pitt.edu/content/upmc-presbyterian-surgical-trauma-icu

