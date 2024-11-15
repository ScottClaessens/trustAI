# function for plotting categories with model means
plot_categories <- function(data, measure, category_means) {
  # category labels
  labels <- c(
    "Agents"            = "Humans",
    "Group_Agents"      = "Groups",
    "AI"                = "AI",
    "Animals"           = "Animals",
    "Animate_Artifacts" = "Animate artifiacts",
    "Inanimate_Nature"  = "Inanimate nature",
    "Food"              = "Food",
    "Abstract"          = "Abstract"
  )
  p <-
    # filter to specific measure
    data %>%
    filter(Measure == measure) %>%
    # plot
    ggplot() +
    geom_jitter(
      data = data,
      mapping = aes(
        x = fct_relevel(Category, unique(category_means$Category)),
        y = Rating
      ),
      width = 0.3,
      height = 0.5,
      size = 0.1,
      colour = "lightgrey"
    ) +
    geom_pointrange(
      data = category_means,
      mapping = aes(
        x = Category,
        y = Estimate,
        ymin = Q2.5,
        ymax = Q97.5
      ),
      size = 0.1
    ) +
    scale_y_continuous(
      name = ifelse(
        measure == "Felicity",
        "Does 'I trust [item]' \nsound weird or natural?",
        "If someone said 'I trust [item]',\nwould that sentence make sense?"
      ),
      breaks = 1:7,
      limits = c(1, 7),
      oob = scales::squish
    ) +
    scale_x_discrete(labels = function(x) labels[x]) +
    theme_minimal() +
    theme(
      strip.placement = "outside",
      strip.text.x = element_text(size = 9),
      strip.text.y = element_text(size = 7),
      legend.title = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_text(size = 9),
      axis.text.x = element_text(size = 7, angle = 45, hjust = 1),
      axis.text.y = element_text(size = 6),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(linewidth = 0.3),
      panel.spacing.x = unit(1.0, "lines"),
      panel.spacing.y = unit(0.7, "lines")
    )
  # save plot
  ggsave(
    plot = p,
    filename = paste0("plots/categories_", measure, ".pdf"),
    width = 5,
    height = 4
  )
  return(p)
}
