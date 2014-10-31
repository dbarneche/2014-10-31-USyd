fit.model <- function(d, x, y) {
  fit <- lm( d[[y]] ~ log10(d[[x]]) )
  data.frame(n=length(d[[y]]), 
             r2=summary(fit)$r.squared,
             a=coef(fit)[1],
             b=coef(fit)[2])
}