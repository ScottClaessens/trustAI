# function to plot model slopes by AI item in study 4
plot_study4_slopes_by_item <- function(study4_fit) {
  out <-
    study4_fit %>%
    # extract parameters
    spread_draws(
      bsp_moreliable, bsp_mogood_intentions, r_Item[item, parameter]
    ) %>%
    pivot_wider(
      names_from = parameter,
      values_from = r_Item
    ) %>%
    # get slopes and difference by item
    transmute(
      item = str_replace_all(item, "\\.", " "),
      `Effect of reliability` = bsp_moreliable + moreliable,
      `Effect of good intentions` = bsp_mogood_intentions + mogood_intentions,
      `Difference (reliability - good intentions)` = 
        `Effect of reliability` - `Effect of good intentions`
    ) %>%
    pivot_longer(cols = !item) %>%
    mutate(
      name = factor(
        name,
        levels = c(
          "Effect of reliability",
          "Effect of good intentions",
          "Difference (reliability - good intentions)"
          )
        )
      ) %>%
    # plot
    ggplot(aes(x = value, y = fct_rev(item))) +
    stat_halfeye() +
    geom_vline(xintercept = 0, linetype = "dashed") +
    facet_grid(. ~ name, switch = "x") +
    labs(x = NULL, y = "AI Item") +
    theme_classic() +
    theme(
      strip.background = element_blank(),
      strip.placement = "outside"
      )
  # save and return
  ggsave(
    plot = out,
    filename = "plots/study4_slopes_by_item.pdf",
    width = 9,
    height = 5
  )
  return(out)
}
