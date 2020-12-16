data {
  int<lower = 0> N;
  int<lower = 2> K;
  int<lower = 0> N_ind;
  
  int<lower = 1, upper = N> first[N_ind];
  int<lower = 1, upper = N> last[N_ind];
  
  int Y[N, K];
}

parameters {
  matrix[K - 1, N] eta_rw;  
  
  vector<lower = 0>[K - 1] sd_init;
  cholesky_factor_corr[K - 1] L_init;
  vector<lower = 0>[K - 1] sd_rw;
  cholesky_factor_corr[K - 1] L_rw;
}

transformed parameters{
  matrix[N, K - 1] mu_raw;
  
  for (i_ind in 1:N_ind) {
    for (j in first[i_ind]:last[i_ind]) {
      if (j == first[i_ind]) {
        mu_raw[j, ] = (diag_pre_multiply(sd_init, L_init) * eta_rw[, j])';
      } else {
        mu_raw[j, ] = mu_raw[j - 1, ] + (diag_pre_multiply(sd_rw, L_rw) * eta_rw[, j])';
      }
    }
  }
}

model {
  vector[K] mu [N];
  
  for (n in 1:N) {
    mu[n, 1] = 0;
    mu[n, 2:K] = mu_raw[n, ]';
  }
  
  to_vector(eta_rw) ~ normal(0, 1);
  sd_init ~ exponential(1);
  L_init ~ lkj_corr_cholesky(1);
  sd_rw ~ exponential(1);
  L_rw ~ lkj_corr_cholesky(1);
  
  for (n in 1:N) {
    target += multinomial_lpmf(Y[n, ] | softmax(mu[n]));
  }
}
