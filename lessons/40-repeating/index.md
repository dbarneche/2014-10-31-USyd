---
layout: lesson
root: ../..
title: Repeating things - the key to writing nice code in R
tutor: Diego
---

<!-- Goals
- split apply combine strategy for data analysis
 -->

**Materials**: If you have not already done so, please [download the lesson materials for this bootcamp](https://github.com/dbarneche/2014-10-31-USyd/raw/gh-pages/data/lessons.zip), unzip, then go to the folder `repeating`, and open (double click) on the file `repeating.Rproj` to open Rstudio.

Previously we looked at how you can use functions to simplify your code. Ideally you have a function that performs a single operation, and now you want to use it many times to do the same operation on lots of different data. The naive way to do that would be something like this:

```r
  res1 <-  f(input1)
  res2 <-  f(input2)
  ...
  res10 <-  f(input10)
```

But this isn't very *nice*. Yes, by using a function, you have reduced a substantial amount of repetition. That **is** nice. But there is still repetition. Repeating yourself will cost you time, both now and later, and potentially introduce some nasty bugs. When it comes to repetition in code: ***Don't***.

<blockquote class="twitter-tweet" lang="en"><p>The more code I read, the more I realize the need to keep repeating: Keep it DRY! Don&#39;t. Repeat. Yourself. <a href="http://t.co/8lDtck2jZO">http://t.co/8lDtck2jZO</a></p>&mdash; Ben Simo (@QualityFrog) <a href="https://twitter.com/QualityFrog/statuses/363789702458904577">August 3, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

The nice way of repeating elements of code is to use a loop of some sort. A loop is a coding structure that reruns the same bit of code over and over, but with only small fragments differing between runs. In R there is a whole family of looping functions, each with their own strengths.

## R's built-in apply library

R has a list of built-in functions for repeating things. This includes a range of functions that allow you to apply some function to a series of objects (eg. vectors, matrices, dataframes or files). This is called the apply family, and includes: `lapply`,  `sapply`,  `tapply`, `aggregate`, `mapply`, `apply`.

Each repeats a function or operation on a series of elements, but they differ in the data types they accept and return. Below, I'll present some simple examples on possible ways to use `tapply`, `apply` and `lapply` (notice that `sapply` is a simplified form of `lapply`, see `?sapply`).

For an example, let's pull up gapminder dataset as before

```r
data <- read.csv("data/gapminder-FiveYearData.csv", stringsAsFactors=FALSE)
```

Imagine that we want to obtain the average life expectancy of all countries in the world on 1992. For that, we can use `tapply`. We first provide a vector (or column of array, matrix or data.frame) to be analysed (life expectancy in this case), and then the splitting category (countries), and finally we provide the function `mean`.

```
# check output
averageLifeExp  <-  tapply(data$lifeExp[data$year == 1992], data$country[data$year == 1992], mean)
```

We could also calculate the square root of the average expectancy for each continent for every year present in the dataset. Notice that R does not have a built-in function for the square root of the average, so we'll have to create our own using the existing functions `sqrt` and `mean`.

```
# check output
avgLifeExpPerContinentPerYear  <-  tapply(data$lifeExp, list(data$continent, data$year), function(x)sqrt(mean(x)))
```

Notice that `tapply` returned a matrix table, with rows containing the unique values of our first category provided in the category list, and columns with the second set of unique values. Whenever possible, `tapply` tries to simplify the output (e.g. an array or vector) because it's argument `simplify` is set to `TRUE` by default. If it had set it to `FALSE`, it would have returned a list instead. At first, the construct for the function `function(x)sqrt(mean(x))` may have looked weird to you. This is what we call [anonymous throwaway functions](http://adv-r.had.co.nz/Functional-programming.html), i.e., R evaluates the function, but it does not save it in your global environment, because it does not have an object (i.e. name) being attributed to it. Throwaway functions are really useful for small simple tasks such as the one above.

Now, from the `avgLifeExpPerContinentPerYear` we could obtain the average values across all years for each one of the continents, i.e., averaging across rows. For that, use another function, `apply`. With `apply` we specify our table, the dimension to which we want to apply a function (i.e. rows or columns) and the function itself. `apply` is primarily designed to work with arrays and matrices, but it can also work with data.frames if the function specified is compatible with the nature (i.e. class) or your columns, otherwise it will probably return and error.

```
apply(avgLifeExpPerContinentPerYear, 1, mean)
```

```
##   Africa Americas     Asia   Europe  Oceania 
## 6.980064 8.031091 7.732961 8.476498 8.618643 
```

which is the same as using the built-in function `rowMeans`. `lapply` is a very handy function that can be applied to atomic vectors, data.frames and lists (in reality, you can also use it with matrices, but be careful). Imagine you have a vector of *names-year* and you want to split those based on `-`. You could use the function `strsplit`

```
# one-element example
strsplit('john-1978', split='-')
## [[1]]
## [1] "john" "1978"

# you can get rid of the list by
strsplit('john-1978', split='-')[[1]]
## [1] "john" "1978"

# multiple-element example, use an lapply loop
x  <-  c('john-1978', 'felix-2043', 'will-1600')
lapply(x, function(x)strsplit(x, split='-')[[1]])
## [[1]]
## [1] "john" "1978"

## [[2]]
## [1] "felix" "2043" 

## [[3]]
## [1] "will" "1600"

# a simplified version using sapply
sapply(x, function(x)strsplit(x, split='-')[[1]])
##      john-1978 felix-2043 will-1600
## [1,] "john"    "felix"    "will"   
## [2,] "1978"    "2043"     "1600"   
```

### Exercise

1. Using R's built-in data `iris`, calculate the difference between max and min values of petal length for each species. 
2. Using R's built-in data set `mtcars` create a vector with the brand of each one of the cars. ***Hint:*** rownames(mtcars) also returns a vector

## The split-apply-combine pattern

By now you may have recognised that many operations that involve looping are instances of the *split-apply-combine* strategy (this term and idea comes from the prolific [Hadley Wickham](http://had.co.nz/), who coined the term in [this
paper](http://vita.had.co.nz/papers/plyr.html)). You start with a bunch of data. Then you then **Split** it up into many smaller datasets, **Apply** a function to each piece, and finally **Combine** the results back together.

Some data arrives already in its pieces - e.g. output files from from a leaf scanner or temperature machine. Your job is then to analyse each bit, and put them together into a larger data set.

Sometimes the combine phase means making a new data frame, other times it might mean something more abstract, like combining a bunch of plots in a report. 

Either way, the challenge for you is to identify the pieces that remain the same between different runs of your function, then structure your analysis around that.

![Split apply combine](splitapply.png)

## The `plyr` package

While R's built in function do work, we're going to introduce you to another method for repeating things using the package [**plyr**](http://had.co.nz/plyr/). plyr is an R Package for Split-Apply-Combine workflows.  Its functional
programming model encourages writing reusable functions which can be called
across varied datasets and frees you from needing to manage for loop indices.

You can load plyr as

```r
install.packages("plyr")
library(plyr)
```

plyr has functions for operating on `lists`, `data.frames` and `arrays`.  Each
function performs:

1. A **split**ting operation
2. **Apply** a function on each split in turn.
3. Re**combine** output data as a single data object.

The functions are named based on which type of object they expect as input
([a]rray, [l]ist or [d]ata frame) and which type of data structure should be
returned as output. Note here that plyr's use of "array" is different to R's, an array in ply can include a vector or matrix.

This gives us 9 core functions **ply.  There are an additional three functions
which will only perform the split and apply steps, and not any combine step.
They're named by their input data type and represent null output by a `_` (see
table)

![Full apply suite](full_apply_suite.png)


### Understanding xxply

Each of the xxply functions (`daply`, `ddply`, `llply`, `laply`,...) has the same structure and has 4 key features and structure:

```r
xxply(.data, .variables, .fun)
```

* The first letter of the function name gives the input type and the second gives the output type.
* .data - gives the data object to be processed
* .variables - identifies the splitting variables
* .fun - gives the function to be called on each piece

### Example

Think about the example above using `tapply`. We input a dataframe that produced a matrix table `avgLifeExpPerContinentPerYear` with the square root of means of life expectancy per continents and years. Let's recreate it using one of plyr's functions

```r
avgLifeExpPerContinentPerYear  <-  ddply(data, .(continent, year), function(x)sqrt(mean(x$lifeExp)))
```

Let's look at what happened here

- The `ddply` function feeds in a `data.frame` (function starts with **d**) and returns another `data.frame` (2nd letter is a **d**)
- the first argument is the data we are operating on: `data`
- the second argument indicates our split criteria `continent` and `year`
- the third is the function to apply `function(x)sqrt(mean(x$lifeExp))`

The great advantage of this approach over R's built-in `tapply` is the flexibility of outputs. For instance, instead of `ddply` we could also have used `daply` of `dlply`. Which to use? You need to decide which type of output is most useful to you, i.e. a `list`, `array` or `data.frame`. Try it yourself. Also, the plyr's notation is slightly cleaner and more intuitive.

We could also use plyr's functions to mimic our second calculation done with `apply` where we extracted the average values across continents. 

```
# return a vector
daply(avgLifeExpPerContinentPerYear, .(continent), function(x)mean(x$V1))
##   Africa Americas     Asia   Europe  Oceania 
## 6.980064 8.031091 7.732961 8.476498 8.618643 

# or a data.frame
ddply(avgLifeExpPerContinentPerYear, .(continent), function(x)mean(x$V1))
##   continent       V1
## 1    Africa 6.980064
## 2  Americas 8.031091
## 3      Asia 7.732961
## 4    Europe 8.476498
## 5   Oceania 8.618643
```

Finally, there's several ways we can represent the split argument:

- using the funky plyr notation: `daply(data, .(splitColumn), function)`
- as a character: `daply(data, "splitColumn", function)`
- or as a formula: `daply(data, ~splitColumn, function)`.

### Exercise 

Make a function that calculates the number of countries in the gapminder dataset. ***Hint:*** use function unique. Use plyr's function that will take a `data.frame` as input and return a `vector` as an output. Split the data by continent.

### Using `plyr` to create quick visualization of multiple plots

Ok, now it gets really fun.

Imagine that we want to analyse boxplots of a certain response per treatment. Using the gapminder dataset, we could, for example, analyse the differences in life expectancy among continents for each year. Typically, the approach I take is to first create a nice boxplot script and than abstract away some of it's implementation by putting into a function. We can start as simple as

```
boxplot(data$lifeExp ~ data$continent)
```
![plot of chunk box_plot1](figure/box_plot1.png)

As you can see, R obviously has a built-in function for boxplots. It's nice but still doesn't look great. Plots in R are very powerful in terms of what you can control. Full control is dictated by arguments to the function `par` (check `?par` for details - the list is massive!). Most of these arguments can also be used directly as functions for other plotting functions such as `plot`, `boxplot`, `hist`, etc. See some of the changes below and try to find what they mean in the help function of `par`

```
boxplot(data$lifeExp ~ data$continent, las=1, main='Global analysis of human life expectancy', xlab='', ylab='', ylim=c(20, 85))
```
![plot of chunk box_plot2](figure/box_plot2.png)

This looks very nice. Now, in order to achieve the main goal (apply this boxplot to all years), we can wrap that around using a function, and then use `plyr` to do the repetition for us. We could, for instance, make the main title also vary by year. Because what we're about to do involves multiple plots, we might as well open a [plotting device](https://stat.ethz.ch/R-manual/R-devel/library/grDevices/html/dev.html) and specify it's dimensions before hand, as well as how many plot panels we want printed in the device. See below

```
niceBoxPlot  <-  function(data) {
    boxplot(data$lifeExp ~ data$continent, las=1, main=unique(data$year), xlab='Continents', ylab='Life expectancy (years)', ylim=c(20, 85))
}

# open a new device. Use windows() 
# instead of quartz() if you're 
# on a Windows machine
quartz(width=10, height=8) # dimensions of plotting device are given in 7 x 7 inches by default
par(mfrow=c(3,4), omi=rep(0.5, 4)) # mfrow sets the number of rows and columns of plotting panels; omi (outer margin in inches) creates an external margin (in inches) around the entire plotting device - it has four values (bottom, left, top, right).
d_ply(gap, .(year), niceBoxPlot)
```
![plot of chunk box_plot3](figure/box_plot3.png)

This already looks pretty handy and nice. But we can improve it by making sure that all continent labels appear simultaneously (some are omitted because the label fonts are too big to display without overlapping them), and we could also drop the repetition of x and y labels, since they are fixed across all plots. To do that we will:

1\. Modify the function `niceBoxPlot`
 * Set arguments `xlab` and `ylab` to empty (i.e. `=''`)
 * Ask R not to plot the continent labels by using setting argument `xaxt='n'`
 * Include a label with rotated text (say, 45 degrees)
2\. Include x and y labels only once outside all plots using the function `mtext`

```
niceboxPlot  <-  function(data) {
    boxplot(data$lifeExp ~ data$continent, las=1, main=unique(data$year), xlab='', ylab='', xaxt='n', ylim=c(20, 85))
    text(1:5, 10, sort(unique(data$continent)), srt=45, xpd=NA, adj=c(1, 0.5))
}

# see `?text` and `par` to understand parameters used for `text`

quartz(width=10, height=8)
par(mfrow=c(3,4), omi=rep(0.5, 4))
d_ply(gap, .(year), niceboxPlot)
mtext("Continents", side=1, outer=TRUE) #side 1 means bottom; outer means relative to entire plotting device
mtext("Life expectancy (years)", side=2, outer=TRUE) #side 2 means left
```
![plot of chunk box_plot4](figure/box_plot4.png)

## Acknowledgements

This material was developed by Daniel Falster and Rich FitzJohn and modified by Diego Barneche. Based on material prepared by Karthik Ram and Hadley Wickam.
