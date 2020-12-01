// generated with brms 2.13.0
functions {
}
data {
  int<lower=1> N;  // number of observations
  int Y[N];  // response variable
  int<lower=1> K;  // number of population-level effects
  matrix[N, K] X;  // population-level design matrix
  // data for group-level effects of ID 1
  int<lower=1> N_1;  // number of grouping levels
  int<lower=1> M_1;  // number of coefficients per level
  int<lower=1> J_1[N];  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_1_1;
  // data for group-level effects of ID 2
  int<lower=1> N_2;  // number of grouping levels
  int<lower=1> M_2;  // number of coefficients per level
  int<lower=1> J_2[N];  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_2_1;
  // data for group-level effects of ID 3
  int<lower=1> N_3;  // number of grouping levels
  int<lower=1> M_3;  // number of coefficients per level
  int<lower=1> J_3[N];  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_3_1;
  // data for group-level effects of ID 4
  int<lower=1> N_4;  // number of grouping levels
  int<lower=1> M_4;  // number of coefficients per level
  int<lower=1> J_4[N];  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_4_1;
  // data for group-level effects of ID 5
  int<lower=1> N_5;  // number of grouping levels
  int<lower=1> M_5;  // number of coefficients per level
  int<lower=1> J_5[N];  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_5_1;
  // data for group-level effects of ID 6
  int<lower=1> N_6;  // number of grouping levels
  int<lower=1> M_6;  // number of coefficients per level
  int<lower=1> J_6[N];  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_6_1;
  // data for group-level effects of ID 7
  int<lower=1> N_7;  // number of grouping levels
  int<lower=1> M_7;  // number of coefficients per level
  int<lower=1> J_7[N];  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_7_1;
  int prior_only;  // should the likelihood be ignored?
}
transformed data {
  int Kc = K - 1;
  matrix[N, Kc] Xc;  // centered version of X without an intercept
  vector[Kc] means_X;  // column means of X before centering
  vector[Kc] sds_X; // scales of columns of X
  for (i in 2:K) {
    means_X[i - 1] = mean(X[, i]);
    sds_X[i - 1] = sd(X[, i]);
    Xc[, i - 1] = X[, i] - means_X[i - 1];
  }
}
parameters {
  vector[Kc] b;  // population-level effects
  real Intercept;  // temporary intercept for centered predictors
  vector<lower=0>[M_1] sd_1;  // group-level standard deviations
  vector<lower=0>[M_2] sd_2;  // group-level standard deviations
  vector<lower=0>[M_3] sd_3;  // group-level standard deviations
  vector<lower=0>[M_4] sd_4;  // group-level standard deviations
  vector<lower=0>[M_5] sd_5;  // group-level standard deviations
  vector<lower=0>[M_6] sd_6;  // group-level standard deviations
  vector<lower=0>[M_7] sd_7;  // group-level standard deviations
  vector[N_1] z_1[M_1];  // standardized group-level effects
  vector[N_2] z_2[M_2];  // standardized group-level effects
  vector[N_3] z_3[M_3];  // standardized group-level effects
  vector[N_4] z_4[M_4];  // standardized group-level effects
  vector[N_5] z_5[M_5];  // standardized group-level effects
  vector[N_6] z_6[M_6];  // standardized group-level effects
  vector[N_7] z_7[M_7];  // standardized group-level effects
}
transformed parameters {
  vector[N_1] r_1_1;  // actual group-level effects
  vector[N_2] r_2_1;  // actual group-level effects
  vector[N_3] r_3_1;  // actual group-level effects
  vector[N_4] r_4_1;  // actual group-level effects
  vector[N_5] r_5_1;  // actual group-level effects
  vector[N_6] r_6_1;  // actual group-level effects
  vector[N_7] r_7_1;  // actual group-level effects
  r_1_1 = (sd_1[1] * (z_1[1]));
  r_2_1 = (sd_2[1] * (z_2[1]));
  r_3_1 = (sd_3[1] * (z_3[1]));
  r_4_1 = (sd_4[1] * (z_4[1]));
  r_5_1 = (sd_5[1] * (z_5[1]));
  r_6_1 = (sd_6[1] * (z_6[1]));
  r_7_1 = (sd_7[1] * (z_7[1]));
}
model {
  // initialize linear predictor term
  vector[N] mu = Intercept + Xc * b;
  for (n in 1:N) {
    // add more terms to the linear predictor
    mu[n] += r_1_1[J_1[n]] * Z_1_1[n] + r_2_1[J_2[n]] * Z_2_1[n] + r_3_1[J_3[n]] * Z_3_1[n] + r_4_1[J_4[n]] * Z_4_1[n] + r_5_1[J_5[n]] * Z_5_1[n] + r_6_1[J_6[n]] * Z_6_1[n] + r_7_1[J_7[n]] * Z_7_1[n];
  }
  // rstanarm default priors
  for(k in 1:Kc) {
    b[k] ~ normal(0.0, 1.0 / sds_X[k]);
  }
  // priors including all constants
  target += normal_lpdf(Intercept | 0, 2.5);
  target += exponential_lpdf(sd_1 | 0.5);
  target += std_normal_lpdf(z_1[1]);
  target += exponential_lpdf(sd_2 | 0.5);
  target += std_normal_lpdf(z_2[1]);
  target += exponential_lpdf(sd_3 | 0.5);
  target += std_normal_lpdf(z_3[1]);
  target += exponential_lpdf(sd_4 | 0.5);
  target += std_normal_lpdf(z_4[1]);
  target += exponential_lpdf(sd_5 | 0.5);
  target += std_normal_lpdf(z_5[1]);
  target += exponential_lpdf(sd_6 | 0.5);
  target += std_normal_lpdf(z_6[1]);
  target += exponential_lpdf(sd_7 | 0.5);
  target += std_normal_lpdf(z_7[1]);
  // likelihood including all constants
  if (!prior_only) {
    target += bernoulli_logit_lpmf(Y | mu);
  }
}
generated quantities {
  // actual population-level intercept
  real b_Intercept = Intercept - dot_product(means_X, b);
}

