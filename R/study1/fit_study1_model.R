# function to random intercept model in study 1
fit_study1_model <- function(data, measure = "Felicity", sample_prior = "no") {
  # subset data
  data <- filter(data, Measure == measure)
  # fit model
  brm(
    formula = Rating ~ 1 + (1 | PID) + (1 | Category/Item),
    data = data,
    family = cumulative,
    prior = c(
      prior(normal(0, 2), class = Intercept),
      prior(exponential(3), class = sd)
    ),
    sample_prior = sample_prior,
    chains = 4,
    cores = 4,
    seed = 2113
  )
}
