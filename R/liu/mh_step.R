#' Single Metropolis-Hastings step
#'
#' @param particle Named vector with elements mu and theta
#' @param y1 Observed data for module 1
#' @param y2 Observed data for module 2
#' @param s1 Standard deviation for module 1
#' @param s2 Standard deviation for module 2
#' @param eta Tempering parameter
#' @param proposal_sd Proposal standard deviation for random walk
#'
#' @return Updated particle after MH step
mh_step <- function(particle, y1, y2, s1, s2, eta, proposal_sd = 0.1) {
  # Propose new values (symmetric random walk)
  proposal <- particle + rnorm(3, mean = 0, sd = proposal_sd)
  names(proposal) <- names(particle)
  
  # Compute log acceptance ratio (proposal is symmetric, so it cancels)
  log_post_prop <- log_posterior(proposal, y1, y2, s1, s2, eta)
  log_post_curr <- log_posterior(particle, y1, y2, s1, s2, eta)
  log_alpha <- log_post_prop - log_post_curr
  
  # Accept or reject
  if (log(runif(1)) < log_alpha) {
    return(proposal)
  } else {
    return(particle)
  }
}