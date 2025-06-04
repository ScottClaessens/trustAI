# function to plot overall histograms from study 4 data
plot_study4_histograms <- function(study4_data) {
  out <-
    study4_data %>%
    mutate(
      Trait = str_to_title(str_replace(Trait, "-", " ")),
      Trait = factor(Trait, levels = c("Trust", "Reliable", "Good Intentions"))
    ) %>%
    ggplot(mapping = aes(x = Score)) +
    geom_bar() +
    scale_x_continuous(name = NULL, breaks = 1:7) +
    scale_y_continuous(name = "Count", expand = c(0, 0)) +
    facet_grid(. ~ Trait, switch = "x") +
    theme_classic() +
    theme(
      strip.background = element_blank(),
      strip.placement = "outside"
    )
  # save and return
  ggsave(
    plot = out,
    filename = "plots/study4_histograms.pdf",
    width = 6,
    height = 3
  )
  return(out)
}
