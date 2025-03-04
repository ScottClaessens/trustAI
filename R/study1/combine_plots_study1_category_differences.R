# function for combining felicity and sense category difference plots in study 1
combine_plots_study1_category_differences <- function(study1_plot_diff_Felicity,
                                                      study1_plot_diff_Sense) {
  # combine plots
  p <- 
    study1_plot_diff_Felicity + 
    plot_spacer() +
    study1_plot_diff_Sense +
    plot_layout(widths = c(1, 0.08, 1))
  # save combined plot
  ggsave(
    plot = p,
    filename = paste0("plots/study1_category_difference.pdf"),
    width = 8,
    height = 4
  )
  return(p)
}
