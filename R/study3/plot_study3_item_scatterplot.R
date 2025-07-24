# function to produce scatter plot of item means from study 3
plot_study3_item_scatterplot <- function(study3_item_means, measure) {
  # pivot item means wider for plot
  data <-
    study3_item_means %>%
    select(Trait, Item, Estimate) %>%
    pivot_wider(
      names_from = Trait,
      values_from = Estimate
    ) %>%
    mutate(
      AI = Item %in% c("ChatGPT", "LLM", "Self_Driving_Car",
                       "AI", "Amazon_Alexa", "Robot"),
      Item = str_replace_all(Item, "_", " ")
      )
  # get title
  title <-
    ifelse(
      measure == "Felicity",
      paste0("Does [...] sound weird or natural?"),
      paste0("If someone said [...], would that sentence make sense?")
    )
  # plotting function
  plotFun <- function(var) {
    p <-
      ggplot(
        data = data,
        mapping = aes(
          x = !!sym(var),
          y = Trust,
          label = Item,
          colour = AI
          )
      ) +
      geom_point() +
      ggrepel::geom_text_repel(
        size = 2.2,
        seed = 1,
        segment.size = 0.1
      ) +
      scale_x_continuous(
        name = ifelse(
          var == "Reliable",
          "[item] is reliable",
          "[item] has good intentions"
        ),
        breaks = 1:7,
        limits = c(1, 7)
      ) +
      scale_y_continuous(
        name = "I trust [item]",
        breaks = 1:7,
        limits = c(1, 7)
      ) +
      scale_colour_manual(values = c("grey40", "red")) +
      theme_classic() +
      theme(legend.position = "none")
    # add title
    if (var == "Reliable") {
      p + ggtitle(title)
    } else {
      p
    }
  }
  # plots
  pA <- plotFun("Reliable")
  pB <- plotFun("Good Intentions")
  # put together
  p <- (pA + pB) + plot_layout(axis_titles = "collect")
  # save plot
  ggsave(
    plot = p,
    filename = paste0("plots/study3_item_scatterplots_", measure, ".pdf"),
    width = 6.5,
    height = 4
  )
  return(p)
}