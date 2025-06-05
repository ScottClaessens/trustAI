# function to plot participant scatter plot from study 4
plot_study4_pid_scatterplot <- function(study4_pid_means) {
  # pivot item means wider for plot
  data <-
    study4_pid_means %>%
    dplyr::select(Trait, PID, Estimate) %>%
    pivot_wider(
      names_from = Trait,
      values_from = Estimate
    ) %>%
    rename(
      Trust = trust,
      Reliable = reliable,
      `Good Intentions` = `good-intentions`
      )
  # plotting function
  plotFun <- function(var) {
    ggplot(
      data = data,
      mapping = aes(
        x = !!sym(var),
        y = Trust
        )
      ) +
      geom_point(size = 1) +
      scale_x_continuous(
        breaks = 1:7,
        limits = c(1, 7)
      ) +
      scale_y_continuous(
        breaks = 1:7,
        limits = c(1, 7)
      ) +
      theme_classic() +
      theme(legend.position = "none")
  }
  # plots
  pA <- plotFun("Reliable")
  pB <- plotFun("Good Intentions")
  # put together
  p <- (pA + pB)
  # save
  ggsave(
    filename = paste0("plots/study4_pid_scatterplot.pdf"),
    plot = p,
    height = 3.5,
    width = 6
  )
  return(p)
}
