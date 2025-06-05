# function to plot model predictions in study 4
plot_study4_model_predictions <- function(study4_fit1) {
  # internal plotting function
  plot_fun <- function(index, resp) {
    plot(
      conditional_effects(
        x = study4_fit1,
        # hold other variable at scale midpoint
        conditions = if (resp == "reliable") {
          data.frame(good_intentions = 4)
        } else {
          data.frame(reliable = 4)
        }
        ),
      points = TRUE,
      point_args = list(
        height = 0.45,
        width = 0.45,
        size = 0.1,
        alpha = 0.2
      ),
      plot = FALSE
      )[[index]] +
      scale_x_continuous(
        name = str_to_title(str_replace(resp, "_", " ")),
        breaks = 1:7,
        limits = c(1, 7)
      ) +
      scale_y_continuous(
        name = "Trust",
        breaks = 1:7,
        limits = c(1, 7)
      ) +
      theme_classic()
  }
  # get both plots
  pA <- plot_fun(index = 1, resp = "reliable")
  pB <- plot_fun(index = 2, resp = "good_intentions")
  # put together
  out <- pA + pB + plot_layout(axis_titles = "collect")
  # save and return
  ggsave(
    plot = out,
    file = "plots/study4_model_predictions.pdf",
    width = 6,
    height = 3
  )
  return(out)
}
