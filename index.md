---
layout: page
title: R-Package: SSDFGP
permalink: /SSDFGP/
---

# R-Package: SSDFGP

<div style="text-align:center;">
Sample Size Determination for Genomic Prediction<br/><br/>
<img src='https://img.shields.io/badge/release%20version-1.0-green.svg'>
<img src='https://img.shields.io/badge/lifecycle-stable-brightgreen.svg'>
<img src='https://img.shields.io/badge/license-MIT-blue.svg'>
</div>


---

This R package provides a simple function to generate an operating curve that can be used for determining reasonable sample size for genomic prediction. 

## Installation

```R
### RUN THIS IN R ###
devtools::install_github("oumarkme/SSDFGP")
library(SSDFGP)
```

- Contact authors via the [GitHub issue page](https://github.com/oumarkme/SSDFGP/issues) or e-mails in the authorship list below if you have any questions.
- Source and binary files are also available ([HERE](https://github.com/oumarkme/SSDFGP/releases)) if you cannot install the package directly from GitHub.
- This package is tested on R versions 3.6.3 and 4.1.1.

## The `RErs.det()` function

The `RErs.det()` function is developed for generating the operating curve function helping users to determine the training set size for genomic prediction.

Usage:

```R
RErs.det(geno, nt = NULL, n_iter = NULL, multi.threads = TRUE)
```

Input:

- `geno`: A numeric data frame. Genotype information (-1, 0, 1 or principle components). (row: sample, column: variants/PCs)
- `nt`: A numeric vector carried training set sizes for r-score simulation. Also known as $n_t$ in the article, which varies from $n_{min}$ to $n_{max}$ by increment of $\delta$ ($n_{min} \leq n_t \leq n_{max}$). This function will evenly determine 10 breakpoints by default (`nt = NULL`). Note that the range of the operating curve will be limited by the given `nt`.

- `n_iter`: A number. Time of iteration of simulating r-scores for each given $n_t$. `n_iter = nt` by default (`n_iter = NULL`)
- `multi.threads`: TRUE/FALSE. When the computer has more than 4 threads, this function will use 75% of total computing power by default.

Output

- `$OC.fig`: Operating curve figure. Points which RErs($n_t$) equal 0.95 and 0.99 are annotated.

  <img src="figs/OCfig.png" alt="OCfig" style="zoom:70%;" />

- `$GC.fig$`: Fitted growth curve and simulated points.

  <img src="figs/GCfig.png" style="zoom:70%;" />

- `$parameter`: Estimated growth curve parameter ($\alpha$, $\beta$, and $\gamma$).

- `$OC.fit$`: The fitted values (RErs$(n_t)$) of the operating curve model. ($1 \leq n_t \leq n_c$).

** Curves are plotted by the `ggplot2` package thus you may easily annotate them with `ggplot2` commands afterward.

## Example

Here we use rice 44k data as an example. The raw dataset is available at [ricediversity.org](http://www.ricediversity.org/data/sets/44kgwas/) and published by [Zhao et al. (2011)](https://doi.org/10.1038/ncomms1467). Load the principal component matrix of the genotype data from the `TSDFGS` package (this should be installed while installing the `SSDFGP` package).

```R
# install.packages("TSDFGS")
library(TSDFGS)
data(TSDFGS)
```

Run the `RErs.det()`function setting $n_t$ ranging from 25 to 225 by increacement of 25.

```R
RErs.det(geno, nt = seq(25, 225, by = 25))
```

## Determine optimal training set

After deciding on the training set size, you may determine the optimal training set by genotype information using the `optTrain()` function from the `TSDFGS` package. (Article available: [Ou and Liao, 2019](https://doi.org/10.1007/s00122-019-03387-0))

```R
# install.packages("TSDFGS")
library(TSDFGS)
optTrain(geno, 1:nrow(geno))
```

## Authorship

- Po-Ya Wu ([Po-Ya.Wu@hhu.de](mailto:Po-Ya.Wu@hhu.de))
  - Article's first author.
  - Institute for Quantitative Genetics and Genomics of Plants, Heinrich Heine University, Düsseldorf, Germany
- Jen-Hsiang Ou ([jen-hsiang.ou@imbim.uu.se](mailto:jen-hsiang.ou@imbim.uu.se))
  - Package maintainer
  - Department of Medical Biochemistry and Microbiology, Uppsala University, Uppsala, Sweden
- Chen-Tuo Liao ([ctliao@ntu.edu.tw](mailto:ctliao@ntu.edu.tw))
  - Project administration, supervisor
  - Department of Agronomy, National Taiwan University, Taipei, Taiwan
