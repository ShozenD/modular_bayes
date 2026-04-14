data {
  int<lower=0> n;
  int<lower=0> M;
  matrix<lower=0, upper=1>[M, n] post_phi;
  vector[n] T;
  vector[n] z;
}
transformed data {
  vector[M] eta = post_phi * z;
  real log_T_sum = sum(log(T));
  real z_sum = sum(z);
  matrix[M, n] log_T_mat = rep_matrix(to_row_vector(log(T)), M);
}
parameters {
  real theta1;
  real<lower=0> theta2;
}
model {
  // Priors for regression coefficients
  theta1 ~ normal(0, 5);
  theta2 ~ normal(0, 5);
  
  // --- Likelihood of second module ---  
  vector[M] log_lik;
  for (m in 1 : M) {
    log_lik[m] = dot_product(z,
                             theta1 + theta2 * to_vector(post_phi[m])
                             + log(T))
                 - sum(T .* exp(theta1 + theta2 * to_vector(post_phi[m])));
  }
  target += log_sum_exp(log_lik) - log(M);
}
