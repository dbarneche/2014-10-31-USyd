randbelow <- function(x){
  randcounter <- 0
  while(runif(1) > x){
    randcounter <- randcounter + 1
  }
  randcounter
}

mysim <- function(x, nreps=100){
  results <- numeric(length = nreps)
  for(i in 1:nreps){
    results[i] <-randbelow(x)
  }
  hist(results, xlab="Number of tries")
}
