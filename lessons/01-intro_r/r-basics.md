---
layout: lesson
root: ../..
title: Getting started in R
tutor: Diego
---

## Using R as a calculator

The simplest thing you could do with R is do arithmetic:

```
1 + 100
```

```
## [1] 101
```

Here, we've added 1 and and 100 together to make 101. The `[1]` preceding this we will explain in a minute. For now, think of it as something that indicates output.

Order of operations is same as in maths class (from highest to lowest precedence)

  - Brackets
  - Exponents
  - Divide
  - Multiply
  - Add
  - Subtract

What will this evaluate to?

```
3 + 5 * 2
```

The "caret" symbol (or "hat") is the exponent (to-the-power-of) operator (read `x ^ y` as "`x` to the power of `y`").  What will this evaluate to?

```
3 + 5 * 2 ^ 2
```

Use brackets (actually parentheses) to group to force the order of evaluation if it differs from the default, or to set your own order.

```
(3 + 5) * 2
```

```
## [1] 16
```

But this can get unwieldy when not needed:

```
(3 + (5 * (2 ^ 2))) # hard to read
3 + 5 * 2 ^ 2       # easier to read, once you know rules
3 + 5 * (2 ^ 2)     # if you forget some rules, this might help
```

See `?Arithmetic` for more information, and two more operators (you can also get there by `?"+"` (note the quotes)).

If R thinks that the statement is incomplete, it will change the prompt from `>` to `+` indicating that it is expecting more input. This is *not* an addition sign! Press "`Esc`" if you want to cancel this statement and return to the prompt.

The usual sort of comparison operators are available:

```
1 == 1  # equality (note two equals signs, read as "is equal to")
```

```
## [1] TRUE
```

```
1 != 2  # inequality (read as "is not equal to")
```

```
## [1] TRUE
```

```
1 <  2  # less than
```

```
## [1] TRUE
```

```
1 <= 1  # less than or equal to
```

```
## [1] TRUE
```

```
1 > 0  # greater than
```

```
## [1] TRUE
```

```
1 >= -9 # greater than or equal to
```

```
## [1] TRUE
```

See `?Comparison` for more information (you can also get there by `help("==")`).

Really small numbers get a scientific notation:

```
2/10000
```

```
## [1] 2e-04
```
which you can write in too:

```
2e-04
```

```
## [1] 2e-04
```

Read `e-XX` as "multiplied by `10^XX`", so `2e-4` is `2 * 10^(-4)`.

## Mathematical functions

R has many built in mathematical functions that will work as you would expect:

```
sin(1)  # trig functions
```

```
## [1] 0.841471
```

```
asin(1) # inverse sin (also for cos and tan)
```

```
## [1] 1.570796
```

```
log(1)  # natural logarithm
```

```
## [1] 0
```

```
log10(10) # base-10 logarithm
```

```
## [1] 1
```

```
log2(100) # base-2 logarithm
```

```
## [1] 6.643856
```

```
exp(0.5) # e^(1/2)
```

```
## [1] 1.648721
```

Plus things like probability density functions for many common distributions, and other mathematical functions (e.g., Gamma, Beta, Bessel). If you need it, it's probably there.

## Variables and assignment
You can assign values to variables using the assignment operator `<-`, like this:

```
x <- 1/40
```

And now the **variable** `x` contains the **value** `0.025`:

```
x
```

```
## [1] 0.025
```

(note that it does not contain the *fraction* 1/40, it contains a *decimal approximation* of this fraction.  This appears exact in this case, but it is not.  These decimal approximations are called "[floating point numbers](http://en.wikipedia.org/wiki/Floating_point)" and at some point you will probably end up having to learn more about them than you'd like).

Look up at the top right pane of RStudio, and you'll see that this has appeared in the "Workspace" pane.

Our variable `x` can be used in place of a number in any calculation that expects a number.

```
log(x)
```

```
## [1] -3.688879
```

```
sin(x)
```

```
## [1] 0.0249974
```

The right hand side of the assignment can be any valid R expression.

It is also possible to use the `=` operator for assignment:

```
x = 1/40
```

...but this is much less common among R users.  The most important thing is to **be consistent** with the operator you use. There are occasionally places where it is less confusing to use `<-` than `=`, and it is the most common symbol used in the community. So I'd recommend `<-`.

Notice that assignment does not print a value.

```
x <- 100
```

Notice also that variables can be reassigned (`x` used to contain the value 0.025 and and now it has the value 100).

Assignment values can contain the variable being assigned to: What will `x` contain after running this?

```
x <- x + 1 #notice how RStudio updates its description of x on the top right tab
```

The right hand side is fully evaluated before the assignment occurs.

Variable names can contain letters, numbers, underscores and periods. The cannot start with a number. They cannot contain spaces at all. Different people use different conventions for long variable names, these include

  * periods.between.words
  * underscores\_between_words
  * camelCaseToSeparateWords

What you use is up to you, but **be consistent**.

### Exercise:

Compute the difference in years between now and the year that you started at university. Divide this by the difference
between now and the year when you were born. Multiply this by 100 to get the percentage of your life spent at university. Use parentheses if you need them, use assignment if you need it.

This problem is as much about thinking about formalising the ingredients of a problem as much as actually getting the syntax correct.
