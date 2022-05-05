---
title: SSDFGP | OuMark.ME
---

# R-package: SSDFGP

### Sample Size Determination for Genomic Prediction

[![R build status](https://github.com/rossellhayes/ipa/workflows/R-CMD-check/badge.svg)](https://github.com/oumarkme/SSDFGP/actions) [![](https://img.shields.io/badge/release%20version-0.1-blue.svg)](https://github.com/oumarkme/SSDFGP) [![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://cran.r-project.org/web/licenses/MIT)

**Depends:**

- R (tested under v3.6.3 and v4.1.1)

**Authorship:**

- Po-Ya Wu (Author)
- Jen-Hsiang Ou (Maintainer)
- Chen-Tuo Liao (Thesis advisor)

**Research article for citing this package:** 

- Training set size determination for genomic prediction (*un-published*)



---

### Methods

#### Termination

- Test set: $S_0$
- Training set: $S_t$
- Candidate set: $S_c$

#### gBLUP model

gBLUP model is used to predict GEBVs for individuals
$$
y_t = \mu \mathbf{1}_{n_t}+g_t+e_t
$$

- $y_t$: phenotype value of training set $S_t$
- $g_t$: the genotypic value of $S_t$

==> Bayesian reproducing kernel Hilbert space (RKHS) was performed to obtain GEBVs. (Using R package: [BGLR](https://cran.r-project.org/web/packages/BGLR/index.html))

#### PC score

Steps:

1. Let $X=[X_cX_0]$, where $n=n_c+n_0$.
2. Standardize $X$ to yield matrix $M=[M_cM_0]$. Where $m_{ij}=\frac{x_{ij}-\bar{x}_j}{s_j}$.
3. Perform PCA to the matrix $M^\top M$ and obtain the PC score matrix $P=[P_cP_0]$

#### Relationship matrix

The whole relationship matrix ($K$) is given by
$$
K = \frac{1}{n}PP^\top
$$

#### The logistic growth curve model

The logistic growth curve model is adopted to fit the relationship between the r-score and the training set size. The logistic growth curve model is described as:
$$
y = \frac{\alpha}{1+\exp (\beta-\gamma x)}.
$$

- $y$: the r-score
- $x$: training set size
- $\alpha$: an unknown parameter relating to the asymptote
- $\beta$: the y-intercept
- $\gamma$: changing rate of r-score from the initial value (determine by the magnitude of $\beta$) to its final value (determine by the magnitude of $\alpha$)

==> The R function, nls (in stats package), is used to perform non-linear least squares estimation for the parameters in the model

#### Procedure of determining the training set
