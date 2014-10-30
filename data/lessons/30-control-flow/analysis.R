source("R/functions.R")

data <- read.csv("data/gapminder-FiveYearData.csv", stringsAsFactors=FALSE)

#### loops
x <- 1
while(x > 0.1){
  x <- runif(1)
  print(x)
}

