source("tests/profiling-example.R")
profvis::profvis(f())

x <- runif(100)
(lb <- bench::mark(
  sqrt(x),
  x ^ 0.5
))

plot(lb)
#> Loading required namespace: tidyr
