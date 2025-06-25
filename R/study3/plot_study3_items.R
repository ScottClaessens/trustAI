# function for plotting items with model means in study 3
plot_study3_items <- function(data, measure, item_means) {
  # trait levels
  traits <- c(
    "Trust" = "I trust [item]",
    "Reliable" = "[item] is reliable",
    "Good Intentions" = "[item] has good intentions"
  )
  # AI items
  AI_items <- c(
    "ChatGPT", "LLM", "Self_Driving_Car",
    "AI", "Amazon_Alexa", "Robot"
  )
  # order
  order <- 
    item_means %>%
    filter(Trait == "Trust") %>%
    arrange(desc(Estimate)) %>%
    pull(Item)
  # plot
  out <-
    data %>%
    filter(Measure == measure) %>%
    mutate(
      Trait = factor(traits[Trait], levels = traits),
      AI = Item %in% AI_items
    ) %>%
    # plot
    ggplot() +
    geom_boxplot(
      mapping = aes(
        x = fct_relevel(Item, order),
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
      data = mutate(
        item_means,
        Trait = factor(traits[Trait], levels = traits),
        AI = Item %in% AI_items
        ),
      mapping = aes(
        x = Item,
        y = Estimate,
        ymin = Q2.5,
        ymax = Q97.5,
        colour = AI
      ),
      size = 0.1
    ) +
    scale_colour_manual(values = c("black", "red")) +
    facet_wrap(
      Trait ~ .,
      ncol = 1,
      strip.position = "top"
      ) +
    scale_y_continuous(
      name = "",
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
    scale_colour_manual(values = c("grey40", "red")) +
    ggtitle(
      ifelse(
        measure == "Sense",
        "Does this sentence make sense?",
        "Does this sentence sound weird or natural?"
        )
    ) +
    theme_minimal() +
    theme(
      strip.text.x = element_text(size = 9),
      legend.position = "none",
      axis.title.x = element_blank(),
      axis.title.y = element_text(size = 7),
      axis.text.x = element_text(size = 7, angle = 45, hjust = 1,
                                 colour = ifelse(order %in% AI_items,
                                                 "red", "grey60")),
      axis.text.y = element_text(size = 6),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_blank()
    )
  # save plot
  ggsave(
    plot = out,
    filename = paste0("plots/study3_items_", measure, ".pdf"),
    width = 6,
    height = 4.5
  )
  return(out)
}
