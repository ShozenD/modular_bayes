#' Compute log importance weights (vectorized)
#'
#' @param particles Matrix with columns: mu, theta (n_particles x 2)
#' @param y2 Observed data for module 2
#' @param s2 Standard deviation for module 2
#' @param eta_curr Current tempering parameter
#' @param eta_next Next tempering parameter (eta_next < eta_curr)
#'
#' @return Vector of log weights
compute_log_weights <- function(particles, y2, s2, eta_curr, eta_next) {
  n_particles <- nrow(particles)
  
  # Vectorized log-likelihood computation
  # gives mu + theta for each particle
  log_liks <- numeric(n_particles)
  
  for (i in seq_len(n_particles)) {
    log_liks[i] <- sum(dnorm(y2,
                             mean = particles[i, "mu"] + particles[i, "tilde_theta"],
                             sd = s2,
                             log = TRUE
    ))
  }
  
  # Log weights: (eta_next - eta_curr) * log_likelihood
  (eta_next - eta_curr) * log_liks
}