data {
  int<lower=0> n1;
  array[n1] real y1;
}
parameters {
  real mu;
}
model {
  target += normal_lpdf(mu | 0, 5);
  target += 1/n1 * normal_lpdf(y1 | mu, 2);
}
generated quantities {
  array[n1] real y1_rep;
  for (i in 1 : n1) {
    y1_rep[i] = normal_rng(mu, 1);
  }
}
