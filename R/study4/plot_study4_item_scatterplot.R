# function to plot item scatter plot from study 4
plot_study4_item_scatterplot <- function(study4_item_means) {
  # pivot item means wider for plot
  data <-
    study4_item_means %>%
    select(Trait, Item, Estimate) %>%
    pivot_wider(
      names_from = Trait,
      values_from = Estimate
    ) %>%
    mutate(
      Item = str_to_title(str_replace_all(Item, "the ", "")),
      Item = str_replace_all(Item, "Ai", "AI"),
      Item = ifelse(Item == "Dall-E", "DALL-E", Item),
      Item = ifelse(Item == "Chatgpt", "ChatGPT", Item)
      ) %>%
    rename(
      Trust = trust,
      Reliable = reliable,
      `Good Intentions` = `good-intentions`
      )
  # plotting function
  plotFun <- function(var) {
    p <-
      ggplot(
        data = data,
        mapping = aes(
          x = !!sym(var),
          y = Trust,
          label = Item
          )
      ) +
      ggrepel::geom_text_repel(
        size = 2,
        max.overlaps = 22,
        force = 10,
        force_pull = 0.1,
        seed = 1,
        colour = "darkgrey",
        segment.color = "grey90",
        segment.size = 0.1
      ) +
      geom_point(
        size = 0.6,
        colour = "red"
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
      theme_classic() +
      theme(legend.position = "none")
    # add title
    if (var == "Reliable") {
      p + ggtitle("If someone said [...], would that sentence make sense?")
    } else {
      p
    }
  }
  # plots
  pA <- plotFun("Reliable")
  pB <- plotFun("Good Intentions")
  # put together
  p <- (pA + pB)
  # save
  ggsave(
    filename = paste0("plots/study4_item_scatterplot.pdf"),
    plot = p,
    height = 3.5,
    width = 6
  )
  return(p)
}
