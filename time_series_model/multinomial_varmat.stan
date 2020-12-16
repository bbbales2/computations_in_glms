data {
  int<lower = 0> N;
  int<lower = 2> K;
  int<lower = 0> N_ind;
  
  int<lower = 1, upper = N> first[N_ind];
  int<lower = 1, upper = N> last[N_ind];
  
  int Y[N, K];
}

parameters {
  matrix[K - 1, N] eta_rw_varmat;  
  
  vector<lower = 0>[K - 1] sd_init_varmat;
  cholesky_factor_corr[K - 1] L_init_varmat;
  vector<lower = 0>[K - 1] sd_rw_varmat;
  cholesky_factor_corr[K - 1] L_rw_varmat;
}

transformed parameters{
  matrix[N, K - 1] mu_raw_varmat;
  
  for (i_ind in 1:N_ind) {
    for (j in first[i_ind]:last[i_ind]) {
      if (j == first[i_ind]) {
        mu_raw_varmat[j, ] = (diag_pre_multiply(sd_init_varmat, L_init_varmat) * eta_rw_varmat[, j])';
      } else {
        mu_raw_varmat[j, ] = mu_raw_varmat[j - 1, ] + (diag_pre_multiply(sd_rw_varmat, L_rw_varmat) * eta_rw_varmat[, j])';
      }
    }
  }
}

model {
  vector[K] mu_varmat [N];
  
  for (n in 1:N) {
    mu_varmat[n, 1] = 0;
    mu_varmat[n, 2:K] = mu_raw_varmat[n, ]';
  }
  
  to_vector(eta_rw_varmat) ~ normal(0, 1);
  sd_init_varmat ~ exponential(1);
  L_init_varmat ~ lkj_corr_cholesky(1);
  sd_rw_varmat ~ exponential(1);
  L_rw_varmat ~ lkj_corr_cholesky(1);
  
  for (n in 1:N) {
    target += multinomial_lpmf(Y[n, ] | softmax(mu_varmat[n]));
  }
}
