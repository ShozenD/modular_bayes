data {
  int<lower=0> n;
  array[n] int N;
  vector[n] T;
  array[n] int y;
  array[n] int z;
}

parameters {
  vector<lower=0, upper=1>[n] phi;
  real theta1;
  real<lower=0> theta2;
}

transformed parameters {
  vector[n] mu = T .* exp(theta1 + theta2 * phi);
}

model {
  phi ~ beta(1,1);
  theta1 ~ normal(0, 5);
  theta2 ~ normal(0, 5);
  
  y ~ binomial(N, phi);
  z ~ poisson(mu);
}
