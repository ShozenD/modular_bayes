#' Run complete SMC algorithm over a tempering schedule
#'
#' @param particles_init Initial particle matrix with columns: mu, theta
#' @param y1 Observed data for module 1
#' @param y2 Observed data for module 2
#' @param s1 Standard deviation for module 1
#' @param s2 Standard deviation for module 2
#' @param eta_schedule Vector of tempering parameters (decreasing from 1 to 0)
#' @param n_mh_steps Number of MH steps for rejuvenation at each iteration
#' @param proposal_sd Proposal standard deviation for MH
#' @param verbose Whether to print progress messages
#'
#' @return List containing:
#'   - final_particles: Final particle matrix after complete SMC
#'   - particle_history: List of particle matrices at each eta step
#'   - eta_schedule: The eta schedule used
#'   - summary_stats: Data frame with summary statistics at each step
run_smc <- function(particles_init, y1, y2, s1, s2,
                    eta_schedule = seq(1, 0, by = -0.1),
                    n_mh_steps = 5, proposal_sd = 0.1, verbose = TRUE) {
  # Validate inputs
  if (!is.matrix(particles_init) || ncol(particles_init) != 3) {
    stop("particles_init must be a matrix with 3 columns (mu, tilde_theta, theta)")
  }
  if (!all(diff(eta_schedule) <= 0)) {
    stop("eta_schedule must be monotonically decreasing")
  }
  if (eta_schedule[1] != 1) {
    warning("eta_schedule does not start at 1")
  }
  if (eta_schedule[length(eta_schedule)] != 0) {
    warning("eta_schedule does not end at 0")
  }
  
  n_steps <- length(eta_schedule) - 1
  n_particles <- nrow(particles_init)
  
  # Storage for results
  particle_history <- vector("list", length = n_steps + 1)
  particle_history[[1]] <- particles_init
  
  summary_stats <- data.frame(
    step = 0:n_steps,
    eta = eta_schedule,
    mu_mean = numeric(n_steps + 1),
    mu_sd = numeric(n_steps + 1),
    theta_mean = numeric(n_steps + 1),
    theta_sd = numeric(n_steps + 1)
  )
  
  # Initial statistics
  summary_stats[1, c("mu_mean", "mu_sd")] <- c(
    mean(particles_init[, "mu"]),
    sd(particles_init[, "mu"])
  )
  summary_stats[1, c("theta_mean", "theta_sd")] <- c(
    mean(particles_init[, "theta"]),
    sd(particles_init[, "theta"])
  )
  
  # Current particles
  particles <- particles_init
  
  if (verbose) {
    cat(sprintf(
      "Starting SMC with %d particles over %d steps\n",
      n_particles, n_steps
    ))
    cat(sprintf(
      "Eta schedule: %.1f to %.1f\n\n",
      eta_schedule[1], eta_schedule[length(eta_schedule)]
    ))
  }
  
  # Main SMC loop
  for (i in seq_len(n_steps)) {
    eta_curr <- eta_schedule[i]
    eta_next <- eta_schedule[i + 1]
    
    if (verbose) {
      cat(sprintf("Step %d/%d: eta %.2f -> %.2f\n", i, n_steps, eta_curr, eta_next))
    }
    
    # Run SMC step
    smc_result <- smc_step(
      particles = particles,
      y1 = y1, y2 = y2, s1 = s1, s2 = s2,
      eta_curr = eta_curr,
      eta_next = eta_next,
      n_mh_steps = n_mh_steps,
      proposal_sd = proposal_sd
    )
    
    # Update particles for next iteration
    particles <- smc_result$rejuvenated
    particle_history[[i + 1]] <- particles
    
    # Store summary statistics
    summary_stats[i + 1, c("mu_mean", "mu_sd")] <- c(
      mean(particles[, "mu"]),
      sd(particles[, "mu"])
    )
    summary_stats[i + 1, c("theta_mean", "theta_sd")] <- c(
      mean(particles[, "theta"]),
      sd(particles[, "theta"])
    )
    
    if (verbose) {
      cat(sprintf(
        "  Mu:    mean=%.4f, sd=%.4f\n",
        summary_stats[i + 1, "mu_mean"],
        summary_stats[i + 1, "mu_sd"]
      ))
      cat(sprintf(
        "  Theta: mean=%.4f, sd=%.4f\n\n",
        summary_stats[i + 1, "theta_mean"],
        summary_stats[i + 1, "theta_sd"]
      ))
    }
  }
  
  if (verbose) {
    cat("SMC complete!\n")
  }
  
  list(
    final_particles = particles,
    particle_history = particle_history,
    eta_schedule = eta_schedule,
    summary_stats = summary_stats
  )
}