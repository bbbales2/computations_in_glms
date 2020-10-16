data {
  int N;
  int M[N];
  int turned_out[N];
  vector[N] male;
}

parameters {
  real intercept;
  real slope;
}

model {
  turned_out ~ binomial_logit(M, intercept + slope * male);
}