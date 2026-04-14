#' Rejuvenate particles using Metropolis-Hastings
#'
#' @param particles Matrix with columns: mu, theta (n_particles x 2)
#' @param y1 Observed data for module 1
#' @param y2 Observed data for module 2
#' @param s1 Standard deviation for module 1
#' @param s2 Standard deviation for module 2
#' @param eta_next Next tempering parameter
#' @param n_mh_steps Number of MH steps per particle
#' @param proposal_sd Proposal standard deviation for random walk
#'
#' @return Matrix of rejuvenated particles
rejuvenate <- function(particles, y1, y2, s1, s2, eta_next,
                       n_mh_steps = 5, proposal_sd = 0.1) {
  n_particles <- nrow(particles)
  
  # Apply MH steps to each particle
  for (i in seq_len(n_particles)) {
    particle <- particles[i, ]
    
    # Multiple MH steps
    for (j in seq_len(n_mh_steps)) {
      particle <- mh_step(particle, y1, y2, s1, s2, eta_next, proposal_sd)
    }
    
    particles[i, ] <- particle
  }
  
  particles
}