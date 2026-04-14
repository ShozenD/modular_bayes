#' Complete SMC step combining importance sampling and rejuvenation
#'
#' @param particles Matrix with columns: mu, theta (n_particles x 2)
#' @param y1 Observed data for module 1
#' @param y2 Observed data for module 2
#' @param s1 Standard deviation for module 1
#' @param s2 Standard deviation for module 2
#' @param eta_curr Current tempering parameter
#' @param eta_next Next tempering parameter
#' @param n_mh_steps Number of MH steps for rejuvenation
#' @param proposal_sd Proposal standard deviation
#'
#' @return List with resampled and rejuvenated particles
smc_step <- function(particles, y1, y2, s1, s2, eta_curr, eta_next,
                     n_mh_steps = 5, proposal_sd = 0.1) {
  # Step 1: Importance sampling
  particles_resampled <- is_resample(particles, y2, s2, eta_curr, eta_next)
  
  # Step 2: Rejuvenation
  particles_rejuvenated <- rejuvenate(
    particles_resampled, y1, y2, s1, s2,
    eta_next, n_mh_steps, proposal_sd
  )
  
  list(
    resampled = particles_resampled,
    rejuvenated = particles_rejuvenated
  )
}