data {
  int<lower=0> M;
  vector[M] mu;
  
  int<lower=0> n2;
  array[n2] real y;
}
transformed data {
  real ybar = mean(y);
}
parameters {
  real theta;
}
model {
  // Prior for theta
  target += normal_lpdf(theta | 0, 2);
  
  // Marginal likelihood
  target += -log(M) + log_sum_exp((mu + theta)*n2*ybar - n2*(mu + theta)^2/2);
}
