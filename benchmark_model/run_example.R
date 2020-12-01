library(cmdstanr)
library(rjson)

data = fromJSON(file = "benchmark_model/mrp_500.json")

mod = cmdstan_model("benchmark_model/mrp.stan")

# Would be nice if didn't need adapt_delta = 0.99
fit = mod$sample(data = data, parallel_chains = 4, adapt_delta = 0.99)
