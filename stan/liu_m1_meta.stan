data {
  int<lower=0> n2;
  array[n2] real y2;
  
  int<lower=0> M;
  real mu_mean;
  real<lower=0> mu_sd;
  array[M] real mu;
}
parameters {
  real mu_sup;
  real theta;
}
model {
  target += normal_lpdf(mu_sup | mu_mean, 1);
  target += 1.0/M * normal_lpdf(mu | mu_sup, mu_sd);
  target += normal_lpdf(y2 | mu_sup + theta, 1);
}
