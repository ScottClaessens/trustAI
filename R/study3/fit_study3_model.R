# function to fit random effects model in study 3
fit_study3_model <- function(data, measure = "Felicity", sample_prior = "no") {
  # subset data
  data <- filter(data, Measure == measure)
  # fit model
  brm(
    formula = Rating | thres(gr = Trait) ~ 1 + (1 | PID) + (0 + Trait | Item),
    data = data,
    family = cumulative,
    prior = c(
      prior(normal(0, 2), class = Intercept),
      prior(exponential(3), class = sd),
      prior(lkj(3), class = cor)
    ),
    sample_prior = sample_prior,
    chains = 4,
    cores = 4,
    seed = 2113
  )
}
