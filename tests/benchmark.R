source("tests/profiling-example.R")
profvis::profvis(f())

x <- runif(100)
(lb <- bench::mark(
  sqrt(x),
  x ^ 0.5
))

plot(lb)
#> Loading required namespace: tidyr

lb[c("expression", "min", "median", "itr/sec", "n_gc")]
#> # A tibble: 2 x 4
#>   expression      min   median `itr/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl>
#> 1 sqrt(x)       865ns   1.05µs   679021.
#> 2 x^0.5        3.78µs   4.17µs   203205.
