rm(list=ls())
library(plyr)
source("R/functions-analyses.R")
source("R/functions-figures.R")

data      <- read.csv("data/gapminder-FiveYearData.csv", stringsAsFactors=FALSE)

quartz(width=10, height=8) #remember to use function windows() if you're on a Windows machine 
par(mfrow=c(3,4), omi=rep(0.5, 4))
d_ply(data, .(year), niceBoxPlot)
mtext("Continents", side=1, outer=TRUE) #side 1 means bottom; outer means relative to entire plotting device
mtext("Life expectancy (years)", side=2, outer=TRUE) #side 2 means left

# one way of saving to pdf


# a better way of saving to pdf


# similar approach to save png



