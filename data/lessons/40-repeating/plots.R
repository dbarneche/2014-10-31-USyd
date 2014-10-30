source("R/functions.R")
library(plyr)

data <- read.csv("data/gapminder-FiveYearData.csv", stringsAsFactors=FALSE)

# Example 1 - Imagine that we want to analyse boxplots of a certain response per treatment. Using the gapminder dataset, we could, for example, analyse the differences in life expectancy among continents for each year. Typically, the approach I take is to first create a nice boxplot script and than abstract away some of it's implementation by putting into a function.
boxplot(data$lifeExp ~ data$continent)

# Improved plot - check ?par
boxplot(data$lifeExp ~ data$continent, las=1, main='Global analysis of human life expectancy', xlab='', ylab='', ylim=c(20, 85))

# This looks very nice. Now, in order to achieve the main goal (apply this boxplot to all years), we can wrap that around using a function, and then use plyr to do the repetition for us. We could, for instance, make the main title also vary by year. Because what we're about to do involves multiple plots, we might as well open a plotting device and specify it's dimensions before hand, as well as how many plot panels we want printed in the device.
# now use the function created based on the above lines
# open a new device. Use windows() 
# instead of quartz() if you're 
# on a Windows machine
quartz(width=10, height=8) # dimensions of plotting device are given in 7 x 7 inches by default
par(mfrow=c(3,4), omi=rep(0.5, 4)) # mfrow sets the number of rows and columns of plotting panels; omi (outer margin in inches) creates an external margin (in inches) around the entire plotting device - it has four values (bottom, left, top, right).
d_ply(data, .(year), niceBoxPlot)

# This already looks pretty handy and nice. But we can improve it by making sure that all continent labels appear simultaneously (some are omitted because the label fonts are too big to display without overlapping them), and we could also drop the repetition of x and y labels, since they are fixed across all plots. To do that we will:
#  1. Modify the function `niceBoxPlot`
#    a) Set arguments `xlab` and `ylab` to empty (i.e. `=''`)
#    b) Ask R not to plot the continent labels by using setting argument `xaxt='n'`
#    c) Include a label with rotated text (say, 45 degrees)
#  2. Include x and y labels only once outside all plots using the function `mtext`
quartz(width=10, height=8) #remember to use function windows() if you're on a Windows machine 
par(mfrow=c(3,4), omi=rep(0.5, 4))
d_ply(data, .(year), niceboxPlotImproved)
mtext("Continents", side=1, outer=TRUE) #side 1 means bottom; outer means relative to entire plotting device
mtext("Life expectancy (years)", side=2, outer=TRUE) #side 2 means left



