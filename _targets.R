options(tidyverse.quiet = TRUE)
library(crew)
library(targets)
library(tarchetypes)
library(tidyverse)

# set options for targets and source R functions
tar_option_set(
  packages = c("bayestestR", "brms", "patchwork", "posterior", "tidyverse"),
  controller = crew_controller_local(workers = 3)
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
      plot_study2_category_differences(study2_fit, measure, study2_category_bfs)
      )
  )
  
)
