# function for combining felicity and sense category plots in study 2
combine_plots_study2_categories <- 
  function(study2_plot_category_1_Place_Trust,
           study2_plot_category_2_Place_Trust,
           study2_plot_category_Trustworthiness,
           measure) {
  # put together
  p <- 
    wrap_plots(
      study2_plot_category_1_Place_Trust,
      study2_plot_category_2_Place_Trust,
      study2_plot_category_Trustworthiness,
      byrow = TRUE
    )
  # save combined plot
  ggsave(
    plot = p,
    filename = paste0("plots/study2_categories_", measure, ".pdf"),
    width = 5.5,
    height = 3
  )
  return(p)
}
