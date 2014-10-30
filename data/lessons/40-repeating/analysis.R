library(plyr)

data <- read.csv("data/gapminder-FiveYearData.csv", stringsAsFactors=FALSE)

# Some examples with the apply family functions
averageLifeExp  <-  tapply(data$lifeExp[data$year == 1992], data$country[data$year == 1992], mean)
avgLifeExpPerContinentPerYear  <-  tapply(data$lifeExp, list(data$continent, data$year), function(x)sqrt(mean(x)))
apply(avgLifeExpPerContinentPerYear, 1, mean) # or use function rowMeans
rowMeans(avgLifeExpPerContinentPerYear)

# separate a name by a given splitting character
strsplit('john-1978', split='-')
# or get rid of the list output
strsplit('john-1978', split='-')[[1]]

# use lapply to do the same at once 
x  <-  list('john-1978', 'felix-2043', 'will-1600')
lapply(x, function(x)strsplit(x, split='-')[[1]])

# a simplified version using sapply
sapply(x, function(x)strsplit(x, split='-')[[1]])

# doing the same with plyr
avgLifeExpPerContinentPerYear  <-  ddply(data, .(continent, year), function(x)sqrt(mean(x$lifeExp)))
# a vector
daply(avgLifeExpPerContinentPerYear, .(continent), function(x)mean(x$V1))
# or a data.frame
ddply(avgLifeExpPerContinentPerYear, .(continent), function(x)mean(x$V1))

