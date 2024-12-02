# function for plotting categories with model means in study 2
plot_study2_categories <- function(data, measure, category_means) {
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
  # plotting function
  plot_fun <- function(resp) {
    # correctly ordered categories
    order <-
      category_means %>%
      filter(Trust_Type == resp) %>%
      arrange(desc(Estimate)) %>%
      pull(Category)
    # get y-axis label
    question <-
      ifelse(
        resp == "1_Place_Trust",
        "I trust [item]",
        ifelse(
          resp == "2_Place_Trust",
          "I trust [item] to do that",
          "[item] is trustworthy"
        )
      )
    ylab <-
      ifelse(
        measure == "Felicity",
        paste0("Does '", question, "' \nsound weird or natural?"),
        paste0("If someone said '", question, 
               "',\nwould that sentence make sense?")
      )
    # filter to specific measure and response
    data %>%
      filter(Measure == measure & Trust_Type == resp) %>%
      # plot
      ggplot() +
      geom_jitter(
        data = data,
        mapping = aes(
          x = fct_relevel(Category, order),
          y = Rating
        ),
        width = 0.3,
        height = 0.5,
        size = 0.01,
        colour = "grey60",
        alpha = 0.3
      ) +
      geom_pointrange(
        data = filter(category_means, Trust_Type == resp),
        mapping = aes(
          x = Category,
          y = Estimate,
          ymin = Q2.5,
          ymax = Q97.5
        ),
        size = 0.1
      ) +
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
  }
  # put together
  out <-
    plot_fun(resp = "1_Place_Trust") +
    plot_fun(resp = "2_Place_Trust") +
    plot_fun(resp = "Trustworthiness") +
    plot_annotation(tag_levels = "a")
  # save plot
  ggsave(
    plot = out,
    filename = paste0("plots/study2_categories_", measure, ".pdf"),
    width = 7,
    height = 3.5
  )
  return(out)
}
