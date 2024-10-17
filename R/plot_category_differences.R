# function to plot category differences
plot_category_differences <- function(category_means, measure) {
  # get posterior mean for AI group
  post_AI <- category_means$post[category_means$Category == "AI"][[1]]
  p <-
    # each category minus AI mean
    category_means %>%
    filter(Category != "AI") %>%
    rowwise() %>%
    mutate(
      Category = str_to_sentence(str_replace(Category, "_", " ")),
      diff = list(post - post_AI)
      ) %>%
    dplyr::select(Category, diff) %>%
    mutate(mean = mean(diff)) %>%
    unnest(c(diff)) %>%
    # plot
    ggplot(
      aes(
        x = diff,
        y = fct_reorder(Category, mean)
        )
    ) +
    tidybayes::stat_halfeye() +
    geom_vline(xintercept = 0, linetype = "dashed") +
    labs(
      title = measure,
      x = "Posterior difference between\ncategory and AI"
      ) +
    theme_classic() +
    theme(axis.title.y = element_blank())
  # save
  ggsave(
    plot = p,
    filename = paste0("plots/category_difference_", measure, ".pdf"),
    width = 5,
    height = 4
  )
  return(p)
}