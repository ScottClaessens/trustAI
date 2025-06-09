# function to fit k-means clustering algorithm to data from study 4
fit_study4_kmeans <- function(study4_data) {
  # get means for every participant
  study4_means <-
    study4_data %>%
    group_by(PID, Trait) %>%
    summarise(Score = mean(Score)) %>%
    pivot_wider(
      names_from = Trait,
      values_from = Score
    ) %>%
    rename(good_intentions = `good-intentions`) %>%
    column_to_rownames(var = "PID")
  # fit kmeans models
  tibble(clusters = 1:10) %>%
    mutate(
      # fit kmeans
      model = map(clusters, function(x) kmeans(study4_means, x)),
      # extract sum of squares
      tot.withinss = map(model, function(x) x$tot.withinss)
      ) %>%
    unnest(tot.withinss)
}
