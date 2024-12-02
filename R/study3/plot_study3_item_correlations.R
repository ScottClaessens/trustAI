# plot correlations between item means in study 3
plot_study3_item_correlations <- function(study3_fit_Felicity,
                                          study3_fit_Sense) {
  # plotting function
  plotFun <- function(study3_fit) {
    # get posterior samples
    post <- posterior_samples(study3_fit)
    # function to extract correlations
    extract_cor <- function(x, y) {
      post[[paste0("cor_Item__Trait", x, "__Trait", y)]]
    }
    # extract correlations
    tribble(
      ~x, ~y,
      "GoodIntentions", "Reliable",
      "GoodIntentions", "Trust",
      "Reliable", "Trust"
    ) %>%
      mutate(
        post = map2(x, y, extract_cor),
        estimate = unlist(map(post, mean)),
        lower = unlist(map(post, quantile, 0.025)),
        upper = unlist(map(post, quantile, 0.975)),
        text = paste0(
          "r = ",
          format(round(estimate, 2), nsmall = 2),
          ",\n95% CI [", 
          format(round(lower, 2), nsmall = 2),
          ", ",
          format(round(upper, 2), nsmall = 2),
          "]"
        ),
        x = ifelse(x == "GoodIntentions", "Good Intentions", x),
        y = ifelse(y == "GoodIntentions", "Good Intentions", y)
      ) %>%
      # plot
      ggplot(
        aes(
          x = x,
          y = fct_rev(y),
          fill = estimate,
          label = text
        )
      ) +
      geom_tile() +
      geom_text(size = 2.5) +
      scale_fill_gradient2(
        high = "red",
        low = "blue",
        limits = c(0, 1)
        ) +
      ggtitle(
        str_split(deparse(substitute(study3_fit)), "_")[[1]][3]
        ) +
      theme_minimal() +
      theme(
        axis.title = element_blank(),
        legend.title = element_blank(),
        panel.grid.major = element_blank()
      )
  }
  # get plots
  pA <- plotFun(study3_fit_Felicity)
  pB <- plotFun(study3_fit_Sense)
  # put together
  p <- (pA + pB) + plot_layout(guides = "collect")
  # save
  ggsave(
    filename = "plots/study3_item_correlations.pdf",
    plot = p,
    height = 3,
    width = 6.5
  )
  return(p)
}
