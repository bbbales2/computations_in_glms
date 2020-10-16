data {
  int N;
  int S;
  int M[N];
  int turned_out[N];
  int<lower =1, upper = S> state_idx[N];
  vector[N] male;
}

parameters {
  real intercept;
  real slope;
  
  real states_intercepts_mean;
  real<lower = 0.0> states_intercepts_sd;
  real states_slopes_mean;
  real<lower = 0.0> states_slopes_sd;

  vector<offset = states_intercepts_mean,
    multiplier = states_intercepts_sd>[S] states_intercepts;
  vector<offset = states_slopes_mean,
    multiplier = states_slopes_sd>[S] states_slopes;
}

model {
  intercept ~ normal(0, 1);
  slope ~ normal(0, 1);
  states_intercepts_mean ~ normal(0, 1);
  states_intercepts_sd ~ normal(0, 1);
  states_slopes_mean ~ normal(0, 1);
  states_slopes_sd ~ normal(0, 1);
  states_intercepts ~ normal(states_intercepts_mean, states_intercepts_sd);
  states_slopes ~ normal(states_slopes_mean, states_slopes_sd);
  
  turned_out ~ binomial_logit(M, intercept + slope * male +
    states_intercepts[state_idx] + states_slopes[state_idx] .* male);
}