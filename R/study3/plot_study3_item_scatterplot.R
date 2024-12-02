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
    mutate(Item = str_replace_all(Item, "_", " "))
  # plotting function
  plotFun <- function(var) {
    ggplot(
      data = data,
      mapping = aes(
        x = !!sym(var),
        y = Trust,
        label = Item
        )
      ) +
      geom_point() +
      ggrepel::geom_text_repel(size = 1.5) +
      scale_x_continuous(
        breaks = 1:7,
        limits = c(1, 7)
      ) +
      scale_y_continuous(
        breaks = 1:7,
        limits = c(1, 7)
      ) +
      theme_classic()
  }
  # plots
  pA <- plotFun("Reliable")
  pB <- plotFun("Good Intentions")
  # put together
  p <- (pA + pB) + plot_annotation(title = measure)
  # save
  ggsave(
    filename = paste0("plots/study3_item_scatterplot_", measure, ".pdf"),
    plot = p,
    height = 3.5,
    width = 6
  )
  return(p)
}