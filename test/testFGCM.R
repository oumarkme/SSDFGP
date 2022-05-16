rm(list = ls())
setwd("~/nas/Projects/SSDFGP/test/")

devtools::install_github("oumarkme/SSDFGP")
library(SSDFGP)
library(TSDFGS)
data(rice44kPCA)

det = RErs.det(geno, seq(25, 225, 25))
