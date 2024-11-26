# function to extract bayes factors for differences from AI category in study 1
extract_study1_category_bayes_factors <- function(fit, prior_fit) {
  # get categories (excluding AI)
  categories <- unique(fit$data$Category)[-1]
  # function to get log bayes factor
  extract_fun <- function(category) {
    # get posterior difference
    post_diff <-
      draws_of(as_draws_rvars(fit)$r_Category[category,])[, 1, 1] -
      draws_of(as_draws_rvars(fit)$r_Category["AI",])[, 1, 1]
    # get prior difference
    prior_diff <-
      draws_of(as_draws_rvars(prior_fit)$r_Category[category,])[, 1, 1] -
      draws_of(as_draws_rvars(prior_fit)$r_Category["AI",])[, 1, 1]
    # get bayes factor for difference
    # small log odds effect size threshold = log(1.68)
    # https://easystats.github.io/effectsize/articles/interpret.html#chen2010big
    bf <- 
      bf_parameters(
        posterior = post_diff,
        prior = prior_diff,
        null = c(-log(1.68), log(1.68)),
        verbose = FALSE
      )
    bf$log_BF
  }
  # return results
  tibble(
    category = categories,
    log_bf = unlist(lapply(categories, extract_fun))
  )
}
