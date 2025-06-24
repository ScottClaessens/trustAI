# function for combining felicity and sense category plots in study 2
combine_plots_study2_categories <- 
  function(study2_plot_category_1_Place_Trust_Felicity,
           study2_plot_category_2_Place_Trust_Felicity,
           study2_plot_category_Trustworthiness_Felicity,
           study2_plot_category_1_Place_Trust_Sense,
           study2_plot_category_2_Place_Trust_Sense,
           study2_plot_category_Trustworthiness_Sense) {
  # put together
  p <- 
    wrap_plots(
      study2_plot_category_1_Place_Trust_Felicity,
      study2_plot_category_2_Place_Trust_Felicity,
      study2_plot_category_Trustworthiness_Felicity,
      study2_plot_category_1_Place_Trust_Sense,
      study2_plot_category_2_Place_Trust_Sense,
      study2_plot_category_Trustworthiness_Sense,
      byrow = FALSE
    ) +
    plot_layout(
      ncol = 2,
      nrow = 3,
      axis_titles = "collect"
      )
  # save combined plot
  ggsave(
    plot = p,
    filename = paste0("plots/study2_categories.pdf"),
    width = 6,
    height = 6
  )
  return(p)
}
