# function for combining felicity and sense item scatterplots in study 3
combine_plots_study3_scatter <- 
  function(study3_plot_item_scatterplot_Felicity,
           study3_plot_item_scatterplot_Sense) {
  # put together
  p <- 
    wrap_plots(
      study3_plot_item_scatterplot_Felicity,
      study3_plot_item_scatterplot_Sense,
      byrow = TRUE
    ) +
    plot_layout(nrow = 2)
  # save combined plot
  ggsave(
    plot = p,
    filename = paste0("plots/study3_item_scatterplots.pdf"),
    width = 6,
    height = 6.5
  )
  return(p)
}
