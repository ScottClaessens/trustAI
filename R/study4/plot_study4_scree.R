# function to produce scree plot for kmeans fits in study 4
plot_study4_scree <- function(study4_kmeans) {
  # plot
  out <-
    ggplot(
      data = study4_kmeans,
      mapping = aes(
        x = clusters,
        y = tot.withinss
      )
    ) +
    geom_line() +
    geom_point() +
    scale_x_continuous(name = "Number of clusters", breaks = 1:10) +
    scale_y_continuous(name = "Total within cluster\nsum of squares") +
    theme_classic()
  # save and return
  ggsave(
    plot = out,
    filename = "plots/study4_scree.pdf",
    width = 5,
    height = 3
  )
  return(out)
}
