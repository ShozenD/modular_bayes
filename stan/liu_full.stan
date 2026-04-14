data {
  int<lower=0> n1;
  int<lower=0> n2;
  array[n1] real z;
  array[n2] real y;
}
parameters {
  real mu;
  real theta;
}
model {
  mu ~ normal(0, 10);
  theta ~ normal(0, 2);
  z ~ normal(mu, 2);
  y ~ normal(mu + theta, 1);
}
