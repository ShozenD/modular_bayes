#' Compute log posterior probability (tempered)
#'
#' @param particle Named vector with elements mu and theta
#' @param y1 Observed data for module 1
#' @param y2 Observed data for module 2
#' @param s1 Standard deviation for module 1
#' @param s2 Standard deviation for module 2
#' @param eta Tempering parameter
#' @param prior_mu_sd Prior standard deviation for mu
#' @param prior_theta_sd Prior standard deviation for theta
#'
#' @return Log posterior probability
log_posterior <- function(particle, y1, y2, s1, s2, eta,
                          prior_mu_sd = 5, prior_theta_sd = sqrt(0.5)) {
  mu <- particle["mu"]
  tilde_theta <- particle["tilde_theta"]
  theta <- particle["theta"]
  
  # Log-likelihood for module 1 (always fully weighted)
  log_lik1 <- sum(dnorm(y1, mean = mu, sd = s1, log = TRUE))
  
  # Log-likelihood for module 2 (tempered by eta)
  log_lik2 <- sum(dnorm(y2, mean = mu + tilde_theta, sd = s2, log = TRUE))
  
  # Log-likelihood for module 2 (not tempered)
  log_lik3 <- sum(dnorm(y2, mean = mu + theta, sd = s2, log = TRUE))
  
  # Log-prior
  log_prior <- dnorm(mu, mean = 0, sd = prior_mu_sd, log = TRUE) +
    dnorm(tilde_theta, mean = 0, sd = prior_theta_sd, log = TRUE) +
    dnorm(theta, mean = 0, sd = prior_theta_sd, log = TRUE)
  
  log_lik1 + eta * log_lik2 + log_lik3 + log_prior
}