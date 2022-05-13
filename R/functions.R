# roxygen2::roxygenise()

##### nt2r #####
#' @name nt2r
#' @title Simulate r-scores of each training set size
#' @description Calculate r-scores (un-target) by in parallel.
#' @import TSDFGS
#' @import parallel
#' @param geno A numeric dataframe of genotype, column represent sites (genotype coding as 1, 0, -1)
#' @param peno A numeric vector of phenotype
#' @param nt Numeric. Number of training set size.
#' @param n_iter Times of iteration. (default = 30)
#' @param n_core Number of cores. (Only tested on MacOS and UNIX-like system)
#' @return A vector of r-scores of each iteration
#' @export
nt2r = function(geno, peno, nt, n_iter = 30, n_core = NULL){
  
  # parallel cores
  if(is.null(n_core)){n_core = round(parallel::detectCores() / 2)}
  
  r = unlist(parallel::mclapply(1:n_iter, function(i) return(max(TSDFGS::optTrain(geno, peno, nt)$TOPscore)), mc.cores = n_core))
  return(r)
}
##### END #####