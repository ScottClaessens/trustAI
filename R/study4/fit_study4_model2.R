# function to fit model 2 in study 4
fit_study4_model2 <- function(study4_data) {
  # fit model
  brm(
    formula = Score | thres(gr = Trait) ~ 1 + (0 + Trait | PID) + 
      (0 + Trait | Item),
    data = study4_data,
    family = cumulative,
    prior = c(
      prior(normal(0, 2), class = Intercept),
      prior(exponential(3), class = sd),
      prior(lkj(3), class = cor)
    ),
    chains = 4,
    cores = 4,
    seed = 2113
    )
}
