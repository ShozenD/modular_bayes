data {
  int<lower=0> n;
  array[n] int N;
  array[n] int y;
}

parameters {
  vector<lower=0, upper=1>[n] phi;
}

model {
  phi ~ beta(1,1);
  y ~ binomial(N, phi);
}
