# function for plotting categories with model means in study 2
plot_study2_categories <- function(data, measure, resp, category_means) {
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
  # correctly ordered categories
  order <-
    category_means %>%
    filter(Trust_Type == resp) %>%
    arrange(desc(Estimate)) %>%
    pull(Category)
  AI <-
    category_means %>%
    filter(Trust_Type == resp) %>%
    arrange(desc(Estimate)) %>%
    mutate(AI = Category == "AI") %>%
    pull(AI)
  # get y-axis label
  ylab <-
    ifelse(
      resp == "1_Place_Trust",
      "I trust [item]",
      ifelse(
        resp == "2_Place_Trust",
        "I trust [item] to do that",
        "[item] is trustworthy"
      )
    )
  # filter to specific measure and response
  p <-
    data %>%
    filter(Measure == measure & Trust_Type == resp) %>%
    mutate(AI = Category == "AI") %>%
    # plot
    ggplot() +
    geom_boxplot(
      mapping = aes(
        x = fct_relevel(Category, order),
        y = Rating,
        colour = AI
      ),
      width = 0.5,
      size = 0.4,
      outlier.shape = NA
    ) +
    scale_colour_manual(values = c("#d9d9d9", "#ffd9d9")) +
    ggnewscale::new_scale_colour() +
    geom_pointrange(
      data = category_means %>% 
        filter(Trust_Type == resp) %>% 
        mutate(AI = Category == "AI"),
      mapping = aes(
        x = Category,
        y = Estimate,
        ymin = Q2.5,
        ymax = Q97.5,
        colour = AI
      ),
      size = 0.4
    ) +
    scale_colour_manual(values = c("black", "red")) +
    scale_y_continuous(
      name = ylab,
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
      legend.position = "none",
      axis.title.x = element_blank(),
      axis.title.y = element_text(size = 9),
      axis.text.x = element_text(
        size = 6, angle = 30, hjust = 1,
        colour = ifelse(AI, "red", "black")
      ),
      axis.text.y = element_text(size = 6),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_blank(),
      panel.spacing.x = unit(1.0, "lines"),
      panel.spacing.y = unit(0.7, "lines")
    )
  # if top plot, add title
  title <-
    ifelse(
      measure == "Felicity",
      paste0("Does [...] sound weird or natural?"),
      paste0("If someone said [...], would that sentence make sense?")
    )
  if (resp == "1_Place_Trust") {
    p + ggtitle(title)
  } else {
    p
  }
}
