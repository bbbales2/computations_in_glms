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
  real states_mean;
  real<lower = 0.0> states_sd;
  vector<offset = states_mean, multiplier = states_sd>[S] states;
}

model {
  intercept ~ normal(0, 1);
  slope ~ normal(0, 1);
  states_mean ~ normal(0, 1);
  states_sd ~ normal(0, 1);
  states ~ normal(states_mean, states_sd);

  turned_out ~ binomial_logit(M, intercept + slope * male + states[state_idx]);
}