# function for combining felicity and sense category plots in study 1
combine_plots_study1_categories <- function(study1_plot_category_Felicity,
                                            study1_plot_category_Sense) {
  # combine plots
  p <- 
    study1_plot_category_Felicity + 
    plot_spacer() +
    study1_plot_category_Sense +
    plot_layout(widths = c(1, 0.08, 1))
  # save combined plot
  ggsave(
    plot = p,
    filename = paste0("plots/study1_categories.pdf"),
    width = 6.5,
    height = 4
  )
  return(p)
}
