# roxygen2::roxygenise()

##### nt2r #####
#' @name nt2r
#' @title Simulate r-scores of each training set size
#' @description Calculate r-scores (un-target) by in parallel.
#' @import TSDFGS
#' @import parallel
#' @param geno A numeric dataframe of genotype, column represent sites (genotype coding as 1, 0, -1)
#' @param nt Numeric. Number of training set size
#' @param n_iter Times of iteration. (default = 30)
#' @param multi.threads Default: TRUE
#' @return A vector of r-scores of each iteration
#' @export
nt2r = function(geno, nt, n_iter = 30, multi.threads = TRUE){
  
  # Parallely calculate r-scores
  if(multi.threads){
    cores = parallel::detectCores()
    if(cores <= 4){
      n_core = max(round(cores/2), 1)
    }else{
      n_core = round(cores * 3 / 4)
      if(n_iter < cores) n_core = n_iter
    }
    r = unlist(parallel::mclapply(1:n_iter, function(i) return(max(TSDFGS::optTrain(geno, seq(nrow(geno)), nt)$TOPscore)), mc.cores = n_core))
  }else{
    r = sapply(1:n_iter, function(i) return(max(TSDFGS::optTrain(geno, seq(nrow(geno)), nt)$TOPscore)))
  }

  return(r)
}
##### END #####



##### FGCM #####
# Fit growth curve model
#' @name FGCM
#' @title Fit logistic growth curve model
#' @description A function for fitting logisti growth model
#' @import parallel
#' @import TSDFGS
#' @param geno Genotype information saved as a dataframe. Columns represent variants (SNPs or PCs).
#' @param n.min Minimum training set size
#' @param n.max Maximum training set size
#' @param by Default: NULL. Training set size tested from n.min and increases by this command. Divided evenly to 10 portions by default.
#' @param n_iter Number of simulation of each training set size. Automatically gave a suitable number by default.
#' @param multi.threads Default: TRUE. Set as FALSE if you just want to run it by single thread.
#' @param plot Default: TRUE. By default, this function will return a plot showing the simulation results and the fitted model.
#' @return Estimation of parameters.
#' @export
FGCM = function(geno, n.min, n.max, by = NULL, n_iter = NULL, multi.threads = TRUE, plot = TRUE){
  
  # Basic setting
  if(is.null(by)){
    nt = round(seq(n.min, n.max, length.out = 10))
  }else{
    nt = round(seq(n.min, n.max, by))
  }
  
  if(is.null(n_iter)) n_iter = length(nt)
  
  # Start simulation
  n_core = detectCores()
  if(multi.threads | n_core > 4){
    result = data.frame(n = rep(nt, each = n_iter), r = NA)
    
    r = parallel::mclapply(1:nrow(result), function(i){
      nt = result$n[i]
      r.score = max(TSDFGS::optTrain(geno, seq(nrow(geno)), nt)$TOPscore)
      return(c(nt, r.score))
    }, mc.cores = round(n_core * 4 / 5))
    
    
    result = data.frame(n = unlist(r)[c(T, F)], r = unlist(r)[c(F, T)])
  }else{
    # NOT TESTED YET
  }
  
  
  # Fit model
  fit = stats::coef(stats::nls(r ~ SSlogis(n, asym, xmid, scal), data = result))
  alpha = as.numeric(fit[1])
  gamma = as.numeric(1 / fit[3])
  beta = as.numeric(fit[2] * gamma)
  return(list(alpha=alpha, beta=beta, gamma=gamma))
  
  # plot
  if(plot){
    logistmodel = function(x) alpha / (1 + exp(beta - gamma * x))
    x = seq(n.min, n.max, length = 100)
    plot(result$n, result$r, xlab = "Training set size", ylab = "r-score")
    graphics::points(x, logistmodel(x), type = "l", col = "red")
  }
}