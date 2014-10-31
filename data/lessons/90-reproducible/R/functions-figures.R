niceBoxPlot  <-  function(data) {
  boxplot(data$lifeExp ~ data$continent, las=1, main=unique(data$year), xlab='', ylab='', xaxt='n', ylim=c(20, 85))
  text(1:5, 10, sort(unique(data$continent)), srt=45, xpd=NA, adj=c(1, 0.5))
}

to.pdf <- function(expr, filename, ..., verbose=TRUE) {
  if ( verbose )
    cat(sprintf("Creating %s\n", filename))
  pdf(filename, ...)
  on.exit(dev.off())
  eval.parent(substitute(expr))
}

to.dev <- function(expr, dev, filename, ..., verbose=TRUE) {
  if ( verbose )
    cat(sprintf("Creating %s\n", filename))
  dev(filename, ...)
  on.exit(dev.off())
  eval.parent(substitute(expr))
}
