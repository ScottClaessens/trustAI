# function for plotting items with model means in study 2
plot_study2_items <- function(data, measure, item_means) {
  # get plotting function
  plot_fun <- function(resp) {
    # correctly ordered items
    order <-
      item_means %>%
      filter(Trust_Type == resp) %>%
      arrange(desc(Estimate)) %>%
      pull(Item)
    AI <- 
      item_means %>%
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
    # get title
    title <-
      ifelse(
        measure == "Felicity",
        paste0("Does [...] sound weird or natural?"),
        paste0("If someone said [...], would that sentence make sense?")
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
        data = item_means %>% 
          mutate(AI = Category == "AI") %>% 
          filter(Trust_Type == resp),
        mapping = aes(
          x = Item,
          y = Estimate,
          ymin = Q2.5,
          ymax = Q97.5,
          colour = AI
        ),
        size = 0.2
      ) +
      scale_colour_manual(values = c("black", "red")) +
      scale_y_continuous(
        name = ylab,
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
      theme_minimal() +
      theme(
        strip.placement = "outside",
        strip.text.x = element_text(size = 9),
        strip.text.y = element_text(size = 7),
        legend.position = "none",
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 7),
        axis.text.x = element_text(
          size = 7, angle = 45, hjust = 1,
          colour = ifelse(AI, "red", "black")
        ),
        axis.text.y = element_text(size = 6),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        panel.spacing.x = unit(1.0, "lines"),
        panel.spacing.y = unit(0.7, "lines")
      )
    if (resp == "1_Place_Trust") {
      p + ggtitle(title)
    } else {
      p
    }
  }
  # put together
  out <-
    plot_fun(resp = "1_Place_Trust") +
    plot_fun(resp = "2_Place_Trust") +
    plot_fun(resp = "Trustworthiness") +
    plot_layout(ncol = 1)
  # save plot
  ggsave(
    plot = out,
    filename = paste0("plots/study2_items_", measure, ".pdf"),
    width = 5.5,
    height = 6.5
  )
  return(out)
}
