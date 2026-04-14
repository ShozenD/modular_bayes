data {
  int<lower=0> n1;
  array[n1] real z;
}
parameters {
  real mu;
}
model {
  mu ~ normal(0, 5);
  z ~ normal(mu, 2);
}
