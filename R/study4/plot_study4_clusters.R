# function to plot clusters from study 4
plot_study4_clusters <- function(study4_data, study4_kmeans) {
  cluster_labels <- c("Sceptics", "Non-agential trusters", "Agential trusters")
  clusters <-
    # get means for every participant
    study4_data %>%
    group_by(PID, Trait) %>%
    summarise(Score = mean(Score), .groups = "drop") %>%
    pivot_wider(
      names_from = Trait,
      values_from = Score
    ) %>%
    rename(good_intentions = `good-intentions`) %>%
    # join clusters
    mutate(
      Cluster = factor(
        cluster_labels[study4_kmeans$model[[3]]$cluster],
        levels = cluster_labels
      )
    )
  # plotting function
  plot_fun <- function(x, y) {
    ggplot(
      data = clusters,
      aes(x = !!sym(x), y = !!sym(y), colour = Cluster)
      ) +
      geom_jitter() +
      scale_x_continuous(
        name = ifelse(
          x == "reliable",
          "[item] is reliable",
          "[item] has good intentions"
        ),
        limits = c(1, 7),
        breaks = 1:7
      ) +
      scale_y_continuous(
        name = ifelse(
          y == "trust",
          "I trust [item]",
          "[item] is reliable"
        ),
        limits = c(1, 7),
        breaks = 1:7
      ) +
      theme_classic()
  }
  pA <- plot_fun(x = "reliable", y = "trust")
  pB <- plot_fun(x = "good_intentions", y = "trust")
  pC <- plot_fun(x = "good_intentions", y = "reliable")
  # put together
  out <- 
    pA + pB + pC + guide_area() +
    plot_layout(
      nrow = 2,
      guides = "collect"
      )
  ggsave(
    plot = out,
    filename = "plots/study4_clusters.pdf",
    height = 6,
    width = 6
  )
  return(out)
}
