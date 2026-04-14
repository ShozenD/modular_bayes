#' Importance sampling resample step
#'
#' @param particles Matrix with columns: mu, theta (n_particles x 2)
#' @param y2 Observed data for module 2
#' @param s2 Standard deviation for module 2
#' @param eta_curr Current tempering parameter
#' @param eta_next Next tempering parameter (eta_next < eta_curr)
#'
#' @return Matrix of resampled particles (same dimensions as input)
is_resample <- function(particles, y2, s2, eta_curr, eta_next) {
  n_particles <- nrow(particles)
  
  # Compute log weights
  log_ws <- compute_log_weights(particles, y2, s2, eta_curr, eta_next)
  
  # Normalize weights on log scale (numerically stable)
  log_ws_normalized <- log_ws - matrixStats::logSumExp(log_ws)
  ws_normalized <- exp(log_ws_normalized)
  
  # Resample indices
  resampled_idx <- sample.int(n_particles,
                              size = n_particles,
                              replace = TRUE,
                              prob = ws_normalized
  )
  
  # Return resampled particles
  particles[resampled_idx, , drop = FALSE]
}