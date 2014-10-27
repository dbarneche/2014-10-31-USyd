---
layout: lesson
root: ../..
title: Flow control and classic looping structures
tutor: Dan
---

<!-- Goals
- learn how to key control structures
 -->

**Materials**: If you have not already done so, please [download the lesson materials for this bootcamp](https://github.com/dbarneche/2014-10-31-USyd/raw/gh-pages/data/lessons.zip), unzip, then go to the folder `looping`, and open (double click) on the file `looping.Rproj` to open Rstudio.

## For loops - when the order of operation is important

When you mention looping, many people immediately reach for `for`. Perhaps
that's because they are already familiar with these other languages,
like basic, python, perl, C, C++ or MATLAB. While `for` is definitely the most
flexible of the looping options, we suggest you avoid it wherever you can in favor of functions in plyr and the like, for the following two reasons:

1. It is not very expressive, i.e. takes a lot of code to do what you want.
2. It permits you to write horrible code that is hard to read and debug.

In fact, we'd encourage you to avoid `for` unless the order of iteration is important. A key feature of all the examples in the `plyr` section is that **order of iteration is not important**.  This is crucial. If each iteration is independent, then you can cycle through them in whatever order you like.

When the order of iteration **is** important, we can use loops.  The basic structure of a `for` loop is 

```r
for(iterator in set of values){
  do a thing
}
```
For example:

```r
for(i in 1:10){
  print(i)
}
```

The `1:10` bit is basically just creating a vector on the fly; you can iterate over any other vector as well.

```r
v <- c("this", "is", "the", "world's", "greatest", "for", "loop")
for(i in v){
  print(i)
}
```

## Nested for loops

We can use a for loop within another for loop to iterate over two things at once (e.g., rows and columns of a matrix).

```r
for(i in 1:5){
  for(j in 1:5){
  	print(paste(i,j))
  }
}
```

Note the variable scoping - `i` is visible from within the `j` loop.  What happens when we try to print `j` from outside the `j` loop?

## While loops - I don't know how far I'm going, but I'll recognise it when I get there

Sometimes you will find yourself needing to repeat an operation until a certain condition is met, rather than doing it for a specific number of times.  In some cases you might be able to hack something together using a `for` loop, but usually you'd be much better off using a `while` loop instead.  `While` loops look and act a lot like `for` loops, but instead of saying: 

```r
for(iterator in set of values){
  do a thing
}
```

You instead say:

```r
while(this condition is true){
  do a thing
} 
```

Let's try an example, shall we?  We'll try to come up with some simple code that generates random numbers between 0 and 1 until it gets one that's less than 0.1.  

```r
while(z > 0.1){
  z <- runif(1)
  print(z)
}
```

But wait, that doesn't work!  What's the problem?

The problem is that we haven't defined `z`, and so the very first time the while loop's condition is checked (`z > 0.1`), `while` just says "Okay, that's not true so I'm not going to execute this block of code".  The same thing would have happened if we defined `z` to be anything less than 0.1.  Let's fix it.

```r
z <- 1
while(z > 0.1){
  z <- runif(1)
  print(z)
}
```

## 

### Exercise

Let's say you want to know how many random numbers you need to draw until you get one that's below a given threshold (i.e., "how many random numbers before I get one less than 0.1?")  Let's create a simulation of that procedure!

1. Create a function `randbelow` that takes a threshold and uses a `while` loop to draw random (`runif`) numbers until it gets a number below the threshold, counting each time it draws a number.

2. Create a function that takes a threshold and the number of reps and uses a `for` loop to call `randbelow`.  You'll need to define an empty numeric vector, e.g., `results <- numeric()` and append results to it, e.g., `results <- c(results, thisresult)` each iteration.

3. Finally, use the results vector from that function to draw and return a histogram.

Let's experiment!  See what the distribution looks like if you try to draw numbers under 0.1 for 100 repetitions.  What about 0.01?  Keep adding zeros (0.001, 0.0001, 0.00001).  What happens to the time it takes to execute your simulation?  Why?

This demonstrates an important part of using loops in code - if you don't think clearly about what you're doing, they can take a long time to execute, or can even go on forever! 



## Loops in simulations

One place where `for` loops shine is in writing simulations; if one iteration depends on the value of a previous iteration, then a `for` loop is probably the best way of repeating things.

In an (unbiased) random walk, each time step we move left or right with probability 0.5.  R has lots of random number generation functions.  The `runif` function generates random numbers uniformly on `[0,1]` so we can draw random steps directions like this:


```r
set.seed(1)
for (i in 1:10){
  step <- 0
  if(runif(1) < 0.5){
    step <- 1
  }
  else{
    step <- -1
  }
  print(step)
}
```

```
## [1] 1
## [1] 1
## [1] -1
## [1] -1
## [1] 1
## [1] -1
## [1] -1
## [1] -1
## [1] -1
## [1] 1
```


Or we could take the `sign` of a standard normal:


```r
set.seed(1)
for (i in 1:10){
  print(sign(rnorm(n=1, mean=0)))
}
```

```
## [1] -1
## [1] 1
## [1] -1
## [1] 1
## [1] 1
## [1] -1
## [1] 1
## [1] 1
## [1] 1
## [1] -1
```


The implementation does not matter.  Now let's wrap that in a function.


```r
random.step <- function() {
  sign(rnorm(n=1, mean=0))
}
```


We can then use this to step 20 steps:


```r
set.seed(1)
x <- 0
for (i in 1:20){
  x <- x + random.step()
}
x
```

```
## [1] 4
```


which will end up somewhere between -20 and 20, but with a mean of 0.

We want to track the entire trajectory:


```r
set.seed(1)
nsteps <- 200
x <- numeric(nsteps + 1) # space to store things in
x[1] <- 0 # start at 0
for (i in seq_len(nsteps)) {
  x[i+1] <- x[i] + random.step()
}
plot(x, type="l", xlab="Step number", ylab="Position")
```

![plot of chunk random_walk1](figure/random_walk1.png)


We might want to run that lots of times, so put it into a function:

```r
random.walk <- function(nsteps, x0=0) {
  x <- numeric(nsteps + 1)
  x[1] <- x0
  for (i in seq_len(nsteps)) {
    x[i+1] <- x[i] + random.step()
    }
  x
}
```


which is now much easier to use:


```r
set.seed(1)
plot(random.walk(400), type="l", xlab="Step number", ylab="Position")
```

![plot of chunk random_walk2](figure/random_walk2.png)



```r
set.seed(1)
nsteps <- 200
nrep <- 40
cols <- rainbow(nrep)
plot(NA, xlim=c(1, nsteps+1), ylim=c(-30, 30), xlab="Step number", ylab="Position")
for (i in 1:nrep){
  lines(random.walk(200), col=cols[i])
}
```

![plot of chunk random_walks](figure/random_walks.png)


## Acknowledgements

This material was developed by Daniel Falster and Rich FitzJohn and modified by Diego Barneche and Dan Warren. Based on material prepared by Karthik Ram and Hadley Wickam.
