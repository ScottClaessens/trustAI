# function to plot category differences in study 2
plot_study2_category_differences <- function(fit, measure, category_bfs) {
  # category labels
  labels <- c(
    "Abstract"             = "Abstract",
    "AI"                   = "AI",
    "Animals"              = "Animals",
    "Animate_Artifacts"    = "Animate artifacts",
    "Food"                 = "Food",
    "Groups"               = "Groups",
    "Humans"               = "Humans",
    "Inanimate_Artifiacts" = "Inanimate artifacts",
    "Inanimate_Nature"     = "Inanimate nature"
  )
  # prepare bfs for plotting
  category_bfs$Category <- 
    str_to_sentence(
      str_replace(
        category_bfs$Category,
        "_",
        " "
      )
    )
  category_bfs$Category <- 
    ifelse(
      category_bfs$Category == "Inanimate artifiacts",
      "Inanimate artifacts",
      category_bfs$Category
      )
  category_bfs$log_bf <- format(round(category_bfs$log_bf, 2), nsmall = 2)
  # extract random effects
  r <- as_draws_rvars(fit)$r_Category
  # get differences from AI
  diffs <- r - r["AI", ]
  diffs <- diffs[rownames(diffs) != "AI", ]
  # get plotting function
  plot_fun <- function(resp) {
    # subset diffs to resp
    diffs <- diffs[, paste0("Trust_Type", resp)]
    # get as tibble
    p <-
      as_tibble(diffs, rownames = "Category") %>%
      rename(diff = !!sym(paste0("Trust_Type", resp))) %>%
      rowwise() %>%
      mutate(
        Category = labels[Category],
        diff = list(draws_of(diff)[, 1]),
        mean = mean(diff)
      ) %>%
      unnest(c(diff)) %>%
      # plot
      ggplot() +
      geom_rect(
        xmin = -log(1.68),
        xmax = log(1.68),
        ymin = 0,
        ymax = 9,
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
        data = filter(category_bfs, Trust_Type == resp),
        aes(
          y = Category,
          label = log_bf
        ),
        x = Inf,
        hjust = 1,
        size = 3
      ) +
      ggtitle(paste0(measure, " - ", str_replace_all(resp, "_", " "))) +
      scale_x_continuous(
        name = "Posterior log odds difference between category and AI",
        limits = c(-6, 6)
      ) +
      theme_classic() +
      theme(axis.title.y = element_blank())
    if (resp != "Trustworthiness") {
      p + theme(axis.title.x = element_blank())
    } else {
      p
    }
  }
  # put together
  out <-
    plot_fun(resp = "1_Place_Trust") +
    plot_spacer() +
    plot_fun(resp = "2_Place_Trust") +
    plot_spacer() +
    plot_fun(resp = "Trustworthiness") +
    plot_layout(
      ncol = 1,
      heights = c(1, -0.3, 1, -0.3, 1)
      ) +
    plot_annotation(tag_levels = "a")
  # save
  ggsave(
    plot = out,
    filename = paste0("plots/study2_category_difference_", measure, ".pdf"),
    width = 5,
    height = 6
  )
  return(out)
}