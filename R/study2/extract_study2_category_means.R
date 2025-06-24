# function to extract category means from study 2
extract_study2_category_means <- function(fit) {
  # tibble with new data
  d <- expand_grid(
    Trust_Type = sort(unique(fit$data$Trust_Type)),
    Category = unique(fit$data$Category)
    )
  # get fitted values from the model
  f <- fitted(
    object = fit,
    newdata = d,
    re_formula = . ~ (0 + Trust_Type | Category),
    scale = "response",
    summary = FALSE
  )
  # convert from probabilities of each level to estimated means
  means <- matrix(0, nrow = nrow(f), ncol = ncol(f))
  for (i in 1:7) means <- means + (f[, , i] * i)
  # add means to data
  d %>%
    mutate(
      post = lapply(
        seq_len(ncol(means)), function(i) as.numeric(means[,i])
      )
    ) %>%
    rowwise() %>%
    mutate(
      Estimate = mean(post),
      Est.Error = sd(post),
      `Q2.5`  = quantile(post, 0.025),
      `Q25`   = quantile(post, 0.250),
      `Q75`   = quantile(post, 0.750),
      `Q97.5` = quantile(post, 0.975)
    ) %>%
    ungroup()
}
