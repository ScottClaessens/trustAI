# function to extract item means in study 4
extract_study4_item_means <- function(study4_fit2) {
  # get fitted values
  newdata <- 
    expand_grid(
      Trait = c("trust", "reliable", "good-intentions"),
      Item = sort(unique(study4_fit2$data$Item))
    )
  f <-
    fitted(
      object = study4_fit2,
      newdata = newdata,
      summary = FALSE,
      re_formula = . ~ (0 + Trait | Item)
    )
  # convert to means
  means <- matrix(0, ncol = ncol(f), nrow = nrow(f))
  for (i in 1:7) means <- means + (f[, , i] * i)
  # add means to data
  newdata %>%
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
    ungroup()
}
