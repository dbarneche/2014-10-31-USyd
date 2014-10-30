---
layout: lesson
root: ../..
title: Some sample functions for looping exercises
tutor: Dan
---

```r
x <- 1
while(x > 0.1){
    x <- runif(1)
    print(x)
}
```
```r
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
```







