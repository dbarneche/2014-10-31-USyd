---
layout: lesson
root: ../..
title: Some notes on vectorization
tutor: Diego
---

## Vectors

Many operations in R are vectorized which means that writing code is more efficient, concise and easy to read.

The idea with vectorized operations is that things can happen in parallel without needing to act on one element at a time.

```
x <- 1:4
y <- 6:9
```

add element wise

```
x + y
x > 2
x >= 2
```
returns logical vectors

```
y == 8

x * y

x / y
```

**Be careful** though: if you add/multiply together vectors that are of different lengths, but the lengths factor, R will silently "recycle" the length of the shorter one:

```
x
```

```
## [1] 1 2 3 4
```

```
x * c(-2, 2)
```

```
## [1] -2  4 -6  8
```

(note how the first and third element have been multiplied by -2 while the second and fourth element are multiplied by 2).

If the length of the shorter vector is not a factor of the length of the longer vector you will get a warning, but **the calculation will happen anyway**:

```
x * c(-2, 0, 2)
```

```
## [1] -2  0  6 -8
## Warning message:
## In x * c(-2, 0, 2) :
##   longer object length is not a multiple of shorter object length
```

This is almost never what you want. Pay attention to warnings. Note that Warnings are different to Errors. We just saw a warning, where what happened is (probably) undesirable but not fatal. You'll get Errors where what happened has been deemed unrecoverable. For example

```
x + z # fails because there is no variable z
```

```
## Error: object 'z' not found
```

Just as with the scalars, as well as doing arithmetic operators we can do comparisons. This returns a new vector of `TRUE` and `FALSE` indicating which elements are less than 10:

```
x < 10
```

```
## [1]  TRUE TRUE TRUE TRUE
```

You can do vector-vector comparisons too:

```
x < y # all false as y is quite small.
```

```
## [1] FALSE FALSE FALSE FALSE
```

And combined arithmetic operations with comparison operations. Both sides of the expression are fully evaluated before the comparison takes place.

```
x > 1/y
```

```
## [1] FALSE FALSE FALSE  TRUE
```

Be careful with comparisons: This compares the first element with -20, the second with 20, the third with -20 and the fourth with 20.

```
x >= c(-20, 20)
```

```
## [1]  TRUE FALSE  TRUE FALSE
```

This does nothing sensible, really, and warns you again:

```
x == c(-2, 0, 2)
```

```
## Warning message:
## In x == c(-2, 0, 2) :
##   longer object length is not a multiple of shorter object length
```

```
## [1] FALSE FALSE FALSE FALSE
```

All the comparison operators work in fairly predictable ways:

```
x == 3
```

```
## [1] FALSE FALSE  TRUE FALSE
```

```
x != 2
```

```
## [1]  TRUE FALSE  TRUE  TRUE
```

## Exercise:

One thing you can do with sequences is you can very informally look at convergent sequences. For example, the sum of squares of the reciprocals of integers:

$$\frac{1}{1} + \frac{1}{4} + \frac{1}{9} + \frac{1}{16}$$

$$\frac{1}{1} + \frac{1}{2^2} + \frac{1}{3^2} + \frac{1}{4^2} +
\cdots + \frac{1}{n^2}$$

1. What is the sum of the first four squares?
2. What is the sum of the first 100?
3. ...of the first 10,000?
4. if $x$ is the answer to 3, what is the square root of $6x$?

### A possible solution

1\.

```
1 + 1/4 + 1/9 + 1/16 # starting to get tedious to type
```

```
## [1] 1.423611
```

2\.

```
squares <- (1:100)^2
sum(1/squares)
```

```
## [1] 1.634984
```

3\.

```
sum(1 / (1:10000)^2)
```

```
## [1] 1.644834
```

4\.

```
x <- sum(1 / (1:10000)^2)
sqrt(x * 6)
```

```
## [1] 3.141497
```

## Matrices

Matrix operations are also vectorized

```
x <- matrix(1:4, 2, 2)
y <- matrix(rep(10, 4), 2, 2)

x * y is not matrix multiplication. It's element wise

x / y is element-wise division.
```

True matrix multiplication is:

```
x %*% y
```

Vectorized operations make code a lot simpler.
