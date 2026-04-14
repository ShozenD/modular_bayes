data {
  int<lower=1> n; // number of participants
  int<lower=1> M; // number of MCMC samples per participant
  vector<lower=0, upper=1>[n] phi_mean;
  vector<lower=0>[n] phi_var;
  real eta; // generalized Bayes weights
}
transformed data {
  vector<lower=0>[n] alpha_hat = phi_mean
                                 .* (phi_mean .* (1 - phi_mean) ./ phi_var
                                     - 1);
  vector<lower=0>[n] beta_hat = (1 - phi_mean)
                                .* (phi_mean .* (1 - phi_mean) ./ phi_var - 1);
}
parameters {
  vector<lower=0, upper=1>[n] phi_sup;
}
model {
  // Prior for surrogate parameters
  phi_sup ~ beta(1, 1);
  
  // --- Posterior-as-data log-score ---
  target += eta / M * beta_lpdf(phi_sup | alpha_hat, beta_hat);
}
