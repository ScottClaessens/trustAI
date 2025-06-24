# function for plotting items with model means in study 1
plot_study1_items <- function(data, measure, item_means) {
  p <-
    # filter to specific measure
    data %>%
    filter(Measure == measure) %>%
    mutate(AI = Category == "AI") %>%
    # plot
    ggplot() +
    geom_boxplot(
      mapping = aes(
        x = fct_relevel(Item, unique(item_means$Item)),
        y = Rating,
        colour = AI
      ),
      width = 0.4,
      size = 0.3,
      outlier.shape = NA
    ) +
    scale_colour_manual(values = c("#d9d9d9", "#ffd9d9")) +
    ggnewscale::new_scale_colour() +
    geom_pointrange(
      data = mutate(item_means, AI = Category == "AI"),
      mapping = aes(
        x = Item,
        y = Estimate,
        ymin = Q2.5,
        ymax = Q97.5,
        colour = AI
      ),
      size = 0.4,
      linewidth = 1.3
    ) +
    scale_colour_manual(values = c("black", "red")) +
    scale_y_continuous(
      name = NULL,
      breaks = 1:7,
      limits = c(1, 7),
      oob = scales::squish
    ) +
    scale_x_discrete(
      labels = function(x) 
        ifelse(
          x %in% c("AI", "ChatGPT", "LLM"), x,
          ifelse(
            x == "Amazon_Alexa", "Amazon Alexa",
            str_to_sentence(str_replace_all(x, "_", " "))
            )
          )
      ) +
    ggtitle(
      ifelse(
        measure == "Felicity",
        "Does 'I trust [item]' sound weird or natural?",
        "If someone said 'I trust [item]', would that sentence make sense?"
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
      axis.text.x = element_text(
        size = 7, angle = 45, hjust = 1,
        colour = ifelse(item_means$Category == "AI", "red", "black")
      ),
      axis.text.y = element_text(size = 6),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_blank(),
      panel.spacing.x = unit(1.0, "lines"),
      panel.spacing.y = unit(0.7, "lines")
    )
  # save plot
  ggsave(
    plot = p,
    filename = paste0("plots/study1_items_", measure, ".pdf"),
    width = 5.5,
    height = 3.5
  )
  return(p)
}
