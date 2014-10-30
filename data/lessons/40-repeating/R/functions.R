niceBoxPlot  <-  function(data) {
  boxplot(data$lifeExp ~ data$continent, las=1, main=unique(data$year), xlab='Continents', ylab='Life expectancy (years)', ylim=c(20, 85))
}

niceboxPlotImproved  <-  function(data) {
  boxplot(data$lifeExp ~ data$continent, las=1, main=unique(data$year), xlab='', ylab='', xaxt='n', ylim=c(20, 85))
  text(1:5, 10, sort(unique(data$continent)), srt=45, xpd=NA, adj=c(1, 0.5))
}

