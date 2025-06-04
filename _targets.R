options(tidyverse.quiet = TRUE)
library(crew)
library(targets)
library(tarchetypes)
library(tidyverse)

# set options for targets and source R functions
tar_option_set(
  packages = c("bayestestR", "brms", "ggnewscale",
               "patchwork", "posterior", "tidyverse")#,
  #controller = crew_controller_local(workers = 2)
  )
tar_source()

# targets pipeline
list(
  
  #### Study 1 ####
  
  # study 1 data file
  tar_target(study1_data_file, "data/study1/study1_data_clean.csv",
             format = "file"),
  # load study 1 data
  tar_target(study1_data, read_csv(study1_data_file, show_col_types = FALSE)),
  # get priors for bayes factor calculations
  tar_target(
    study1_prior_fit,
    fit_study1_model(study1_data, sample_prior = "only")
    ),
  # loop over two measures
  tar_map(
    values = tibble(measure = c("Felicity", "Sense")),
    # fit model
    tar_target(study1_fit, fit_study1_model(study1_data, measure)),
    # extract category means
    tar_target(
      study1_category_means,
      extract_study1_category_means(study1_fit)
      ),
    # extract item means
    tar_target(study1_item_means, extract_study1_item_means(study1_fit)),
    # extract category bayes factors
    tar_target(
      study1_category_bfs,
      extract_study1_category_bayes_factors(study1_fit, study1_prior_fit)
      ),
    # plot categories
    tar_target(
      study1_plot_category,
      plot_study1_categories(study1_data, measure, study1_category_means)
      ),
    # plot items
    tar_target(
      study1_plot_item,
      plot_study1_items(study1_data, measure, study1_item_means)
      ),
    # plot category differences
    tar_target(
      study1_plot_diff,
      plot_study1_category_differences(study1_fit, measure, study1_category_bfs)
      )
  ),
  # combined plots
  tar_target(
    study1_plot_category,
    combine_plots_study1_categories(study1_plot_category_Felicity,
                                    study1_plot_category_Sense)
  ),
  
  #### Study 2 ####
  
  # study 2 data file
  tar_target(study2_data_file, "data/study2/study2_data_clean.csv",
             format = "file"),
  # load study 2 data
  tar_target(study2_data, read_csv(study2_data_file, show_col_types = FALSE)),
  ## get priors for bayes factor calculations
  tar_target(
    study2_prior_fit,
    fit_study2_model(study2_data, sample_prior = "only")
    ),
  # loop over two measures
  tar_map(
    values = tibble(measure = c("Felicity", "Sense")),
    # fit model
    tar_target(study2_fit, fit_study2_model(study2_data, measure)),
    # extract category means
    tar_target(
      study2_category_means,
      extract_study2_category_means(study2_fit)
      ),
    # extract item means
    tar_target(study2_item_means, extract_study2_item_means(study2_fit)),
    # extract category bayes factors
    tar_target(
      study2_category_bfs,
      extract_study2_category_bayes_factors(study2_fit, study2_prior_fit)
      ),
    # plot categories
    tar_target(
      study2_plot_category,
      plot_study2_categories(study2_data, measure, study2_category_means)
      ),
    # plot items
    tar_target(
      study2_plot_item,
      plot_study2_items(study2_data, measure, study2_item_means)
      ),
    # plot category differences
    tar_target(
      study2_plot_diff,
      plot_study2_category_differences(study2_fit, measure, 
                                       study2_category_bfs)
      )
  ),
  
  #### Study 3 ####
  
  # study 3 data file
  tar_target(study3_data_file, "data/study3/study3_data_clean.csv",
             format = "file"),
  # load study 3 data
  tar_target(study3_data, read_csv(study3_data_file, show_col_types = FALSE)),
  # loop over two measures
  tar_map(
    values = tibble(measure = c("Felicity", "Sense")),
    # fit model
    tar_target(study3_fit, fit_study3_model(study3_data, measure)),
    # extract item means
    tar_target(study3_item_means, extract_study3_item_means(study3_fit)),
    # plot items
    tar_target(
      study3_plot_item,
      plot_study3_items(study3_data, measure, study3_item_means)
    ),
    # plot item scatterplot
    tar_target(
      study3_plot_item_scatterplot,
      plot_study3_item_scatterplot(study3_item_means, measure)
    )
  ),
  # plot item correlations
  tar_target(
    study3_plot_item_correlations,
    plot_study3_item_correlations(study3_fit_Felicity, study3_fit_Sense)
  ),
  
  #### Study 4 ####
  
  # study 4 data file
  tar_target(study4_data_file, "data/study4/study4_clean_data.csv",
             format = "file"),
  # load study 4 data
  tar_target(study4_data, load_study4_data(study4_data_file)),
  # fit model
  tar_target(study4_fit, fit_study4_model(study4_data)),
  # plot model predictions
  tar_target(
    study4_plot_model_predictions,
    plot_study4_model_predictions(study4_fit)
    ),
  # plot histograms
  tar_target(study4_plot_histograms, plot_study4_histograms(study4_data))
  
)
