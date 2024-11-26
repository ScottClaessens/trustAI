# function to extract bayes factors for differences from AI category in study 2
extract_study2_category_bayes_factors <- function(fit, prior_fit) {
  # get categories (excluding AI)
  categories <- unique(fit$data$Category)[-1]
  # function to get log bayes factor
  extract_fun <- function(category, Trust_Type) {
    # get posterior difference
    post_diff <-
      draws_of(as_draws_rvars(fit)$r_Category[category, Trust_Type]) -
      draws_of(as_draws_rvars(fit)$r_Category["AI", Trust_Type])
    # get prior difference
    prior_diff <-
      draws_of(as_draws_rvars(prior_fit)$r_Category[category, Trust_Type]) -
      draws_of(as_draws_rvars(prior_fit)$r_Category["AI", Trust_Type])
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
  expand_grid(
    Trust_Type = paste0("Trust_Type", c("1_Place_Trust", "2_Place_Trust",
                                        "Trustworthiness")),
    Category = categories
    ) %>%
    mutate(
      log_bf = unlist(map2(Category, Trust_Type, extract_fun)),
      Trust_Type = str_remove(Trust_Type, "Trust_Type")
      )
}
