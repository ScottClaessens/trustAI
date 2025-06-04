# function to fit model in study 4
fit_study4_model <- function(study4_data) {
  # get data in wide format for modelling
  study4_data <- 
    study4_data %>%
    dplyr::select(!c(Attention_Check, Order)) %>%
    pivot_wider(
      names_from = Trait,
      values_from = Score
    ) %>%
    rename(good_intentions = `good-intentions`)
  # fit model
  brm(
    formula = trust ~ 1 + mo(reliable) + mo(good_intentions) + (1 | PID) +
      (1 + mo(reliable) + mo(good_intentions) | Item),
    data = study4_data,
    family = cumulative,
    prior = c(
      prior(normal(0, 2), class = Intercept),
      prior(normal(0, 1), class = b),
      prior(exponential(3), class = sd),
      prior(lkj(3), class = cor)
    ),
    chains = 4,
    cores = 4,
    seed = 2113
    )
}
