# function to extract category means from study 1
extract_study1_category_means <- function(fit) {
  # tibble with new data
  d <- tibble(Category = unique(fit$data$Category))
  # get fitted values from the model
  f <- fitted(
    object = fit,
    newdata = d,
    re_formula = . ~ (1 | Category),
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
      `Q97.5` = quantile(post, 0.975)
    ) %>%
    ungroup() %>%
    arrange(desc(Estimate))
}
