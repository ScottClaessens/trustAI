# function to plot category differences
plot_category_differences <- function(fit, measure, category_bfs) {
  # prepare bfs for plotting
  category_bfs$category <- 
    str_to_sentence(
      str_replace(
        category_bfs$category,
        "_",
        " "
      )
    )
  category_bfs$log_bf <- format(round(category_bfs$log_bf, 2), nsmall = 2)
  # extract random effects
  r <- as_draws_rvars(fit)$r_Category
  # get differences from AI
  diffs <- r - r["AI", ]
  diffs <- diffs[rownames(diffs) != "AI", ]
  # get x limits for plot (just below/above 95% CIs)
  xlims <- c(min(quantile(diffs, 0.02)), max(quantile(diffs, 0.995)))
  # get as tibble
  p <-
    as_tibble(diffs, rownames = "Category") %>%
    rename(diff = Intercept) %>%
    rowwise() %>%
    mutate(
      Category = str_to_sentence(str_replace(Category, "_", " ")),
      diff = list(draws_of(diff)[, 1]),
      mean = mean(diff)
      ) %>%
    unnest(c(diff)) %>%
    # plot
    ggplot(
    ) +
    geom_rect(
      xmin = -log(1.68),
      xmax = log(1.68),
      ymin = 0,
      ymax = 8,
      fill = "lightgrey"
    ) +
    geom_vline(xintercept = 0, linetype = "dashed", linewidth = 0.3) +
    tidybayes::stat_pointinterval(
      aes(
        x = diff,
        y = fct_reorder(Category, mean)
      )
    ) +
    geom_text(
      data = category_bfs,
      aes(
        y = category,
        label = log_bf
      ),
      x = Inf,
      hjust = 1
    ) +
    ggtitle(measure) +
    scale_x_continuous(
      name = "Posterior log odds difference\nbetween category and AI",
      limits = xlims
      ) +
    theme_classic() +
    theme(axis.title.y = element_blank())
  # save
  ggsave(
    plot = p,
    filename = paste0("plots/category_difference_", measure, ".pdf"),
    width = 5,
    height = 3
  )
  return(p)
}