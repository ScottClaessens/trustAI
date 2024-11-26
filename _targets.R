options(tidyverse.quiet = TRUE)
library(targets)
library(tarchetypes)
library(tidyverse)

# set options for targets and source R functions
tar_option_set(packages = c("bayestestR", "brms", "posterior", "tidyverse"))
tar_source()

# targets pipeline
list(
  
  #### Study 1 ####
  
  # data file
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
  )
)
