

##### nt2r #####
#' 
#' @description Calculate r-scores (un-target) by in parallel.
#' @import TSDFGS
#' @import parallel
nt2r = function(geno, peno, nt, n_iter = 30, n_core = NULL){
  
  # parallel cores
  if(is.null(n_core)){n_core = round(parallel::detectCores() / 2)}
  
  r = unlist(parallel::mclapply(1:n_iter, function(i) return(max(TSDFGS::optTrain(geno, peno, nt)$TOPscore)), mc.cores = n_core))
  return(r)
}
##### END #####