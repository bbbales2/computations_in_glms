data {
  int<lower=1> N;  // number of observations
  int y[N];        // response variable

  int<lower = 1> K;  // number of population-level effects
  matrix[N, K] X;    // population-level design matrix

  int<lower = 1> N_age;
  int<lower = 1> N_educ;
  int<lower = 1> N_educ_age;
  int<lower = 1> N_educ_eth;
  int<lower = 1> N_eth;
  int<lower = 1> N_male_eth;
  int<lower = 1> N_state;
  
  int<lower=1> J_age[N];
  int<lower=1> J_educ[N];
  int<lower=1> J_educ_age[N];
  int<lower=1> J_educ_eth[N];
  int<lower=1> J_eth[N];
  int<lower=1> J_male_eth[N];
  int<lower=1> J_state[N];
  
  real<lower=0.0> prior_scale_sd;
  real<lower=0.0> prior_scale_Intercept;
  real<lower=0.0> prior_scale_b;
}

transformed data {
  int Kc = K - 1;
  matrix[N, Kc] Xc;    // centered version of X without an intercept
  vector[Kc] means_X;  // column means of X before centering
  vector[Kc] sds_X;    // scales of columns of X
  for (i in 2:K) {
    means_X[i - 1] = mean(X[, i]);
    sds_X[i - 1] = sd(X[, i]);
    Xc[, i - 1] = X[, i] - means_X[i - 1];
  }
}

parameters {
  vector[Kc] b;    // population-level effects
  real Intercept;  // intercept for centered predictors
  
  real<lower=0> sd_age;
  real<lower=0> sd_educ;
  real<lower=0> sd_educ_age;
  real<lower=0> sd_educ_eth;
  real<lower=0> sd_eth;
  real<lower=0> sd_male_eth;
  real<lower=0> sd_state;

  vector[N_age] z_age;
  vector[N_educ] z_educ;
  vector[N_educ_age] z_educ_age;
  vector[N_educ_eth] z_educ_eth;
  vector[N_eth] z_eth;
  vector[N_male_eth] z_male_eth;
  vector[N_state] z_state;
}

transformed parameters {
  vector[N_age] r_age = sd_age * z_age;
  vector[N_educ] r_educ = sd_educ * z_educ;
  vector[N_educ_age] r_educ_age = sd_educ_age * z_educ_age;
  vector[N_educ_eth] r_educ_eth = sd_educ_eth * z_educ_eth;
  vector[N_eth] r_eth = sd_eth * z_eth;
  vector[N_male_eth] r_male_eth = sd_male_eth * z_male_eth;
  vector[N_state] r_state = sd_state * z_state;
}

model {
  // initialize linear predictor term
  vector[N] mu = Intercept + Xc * b
    + r_age[J_age]
    + r_educ[J_educ]
    + r_educ_age[J_educ_age]
    + r_educ_eth[J_educ_eth]
    + r_eth[J_eth]
    + r_male_eth[J_male_eth]
    + r_state[J_state];

  y ~ bernoulli_logit(mu);

  // rstanarm default priors
  b ~ normal(0.0, prior_scale_b ./ sds_X);

  Intercept ~ normal(0.0, prior_scale_Intercept);
  
  z_age ~ std_normal();
  z_educ ~ std_normal();
  z_educ_age ~ std_normal();
  z_educ_eth ~ std_normal();
  z_eth ~ std_normal();
  z_male_eth ~ std_normal();
  z_state ~ std_normal();
  
  // custom sd priors -- rstanarm default is 1.0
  sd_age ~ exponential(prior_scale_sd);
  sd_educ ~ exponential(prior_scale_sd);
  sd_educ_age ~ exponential(prior_scale_sd);
  sd_educ_eth ~ exponential(prior_scale_sd);
  sd_eth ~ exponential(prior_scale_sd);
  sd_male_eth ~ exponential(prior_scale_sd);
  sd_state ~ exponential(prior_scale_sd);
}

generated quantities {
  // actual population-level intercept
  real b_Intercept = Intercept - dot_product(means_X, b);
}
