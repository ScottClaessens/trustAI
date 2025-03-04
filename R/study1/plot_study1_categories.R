# function for plotting categories with model means in study 1
plot_study1_categories <- function(data, measure, category_means) {
  # category labels
  labels <- c(
    "Agents"            = "Humans",
    "Group_Agents"      = "Groups",
    "AI"                = "AI",
    "Animals"           = "Animals",
    "Animate_Artifacts" = "Animate artifacts",
    "Inanimate_Nature"  = "Inanimate nature",
    "Food"              = "Food",
    "Abstract"          = "Abstract"
  )
  # order of x-axis
  order <-
    category_means %>%
    arrange(desc(Estimate)) %>%
    pull(Category)
  p <-
    # filter to specific measure
    data %>%
    filter(Measure == measure) %>%
    # plot
    ggplot() +
    geom_jitter(
      data = mutate(data, AI = Category == "AI"),
      mapping = aes(
        x = factor(Category, levels = order),
        y = Rating,
        colour = AI
      ),
      width = 0.3,
      height = 0.5,
      size = 0.01
    ) +
    scale_colour_manual(values = c("#d9d9d9", "#ffd9d9")) +
    ggnewscale::new_scale_colour() +
    geom_linerange(
      data = mutate(category_means, AI = Category == "AI"),
      mapping = aes(
        x = Category,
        ymin = Q2.5,
        ymax = Q97.5,
        colour = AI
      )
    ) +
    geom_pointrange(
      data = mutate(category_means, AI = Category == "AI"),
      mapping = aes(
        x = Category,
        y = Estimate,
        ymin = Q25,
        ymax = Q75,
        colour = AI
      ),
      size = 0.6,
      linewidth = 1.3
    ) +
    scale_colour_manual(values = c("black", "red")) +
    scale_y_continuous(
      name = NULL,
      breaks = 1:7,
      limits = c(1, 7),
      oob = scales::squish
    ) +
    scale_x_discrete(labels = function(x) labels[x]) +
    ggtitle(
      ifelse(
        measure == "Felicity",
        "Does 'I trust [item]'\nsound weird or natural?",
        "If someone said 'I trust [item]',\nwould that sentence make sense?"
        )
      ) +
    theme_minimal() +
    theme(
      strip.placement = "outside",
      strip.text.x = element_text(size = 9),
      strip.text.y = element_text(size = 7),
      legend.position = "none",
      axis.title.x = element_blank(),
      axis.title.y = element_text(size = 9),
      axis.text.x = element_text(size = 9, angle = 45, hjust = 1,
                                 colour = ifelse(order == "AI", "red", "black")),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(linewidth = 0.3),
      panel.spacing.x = unit(1.0, "lines"),
      panel.spacing.y = unit(0.7, "lines")
    )
  return(p)
}
