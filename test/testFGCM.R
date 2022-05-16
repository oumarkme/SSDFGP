rm(list = ls())
setwd("~/nas/Projects/SSDFGP/test/")

library(TSDFGS)
library(parallel)
source("../R/functions.R")
data(rice44kPCA)

par = FGCM(geno)
