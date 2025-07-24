options(tidyverse.quiet = TRUE)
library(crew)
library(targets)
library(tarchetypes)
library(tidyverse)

# set options for targets and source R functions
tar_option_set(
  packages = c("bayestestR", "brms", "ggnewscale",
               "patchwork", "posterior", "tidybayes", "tidyverse")#,
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
    tar_map(
      values = tibble(
        resp = c("1_Place_Trust", "2_Place_Trust", "Trustworthiness")
      ),
      tar_target(
        study2_plot_category,
        plot_study2_categories(
          study2_data, measure, resp, study2_category_means
        )
      )
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
  # combined plots
  tar_target(
    study2_plot_category_Felicity,
    combine_plots_study2_categories(
      study2_plot_category_1_Place_Trust_Felicity,
      study2_plot_category_2_Place_Trust_Felicity,
      study2_plot_category_Trustworthiness_Felicity,
      measure = "Felicity"
    )
  ),
  tar_target(
    study2_plot_category_Sense,
    combine_plots_study2_categories(
      study2_plot_category_1_Place_Trust_Sense,
      study2_plot_category_2_Place_Trust_Sense,
      study2_plot_category_Trustworthiness_Sense,
      measure = "Sense"
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
  # combine scatterplots
  tar_target(
    study3_plot_item_scatterplot,
    combine_plots_study3_scatter(
      study3_plot_item_scatterplot_Felicity,
      study3_plot_item_scatterplot_Sense
    )
  ),
  
  #### Study 4 ####
  
  # study 4 data file
  tar_target(study4_data_file, "data/study4/study4_clean_data.csv",
             format = "file"),
  # load study 4 data
  tar_target(study4_data, load_study4_data(study4_data_file)),
  # fit models
  tar_target(study4_fit1, fit_study4_model1(study4_data)),
  tar_target(study4_fit2, fit_study4_model2(study4_data)),
  # plot model predictions
  tar_target(
    study4_plot_model_predictions,
    plot_study4_model_predictions(study4_fit1)
    ),
  # plot histograms
  tar_target(study4_plot_histograms, plot_study4_histograms(study4_data)),
  # plot slopes by item
  tar_target(
    study4_plot_slopes_by_item,
    plot_study4_slopes_by_item(study4_fit1)
    ),
  # extract item means
  tar_target(study4_item_means, extract_study4_item_means(study4_fit2)),
  # plot item scatter plots
  tar_target(
    study4_plot_item_scatterplot,
    plot_study4_item_scatterplot(study4_item_means)
  ),
  # extract participant means
  tar_target(study4_pid_means, extract_study4_pid_means(study4_fit2)),
  # plot participant scatter plots
  tar_target(
    study4_plot_pid_scatterplot,
    plot_study4_pid_scatterplot(study4_pid_means)
  ),
  # fit kmeans models with differing numbers of clusters
  tar_target(study4_kmeans, fit_study4_kmeans(study4_data)),
  # plot scree plot
  tar_target(study4_plot_scree, plot_study4_scree(study4_kmeans)),
  # plot clusters
  tar_target(
    study4_plot_clusters,
    plot_study4_clusters(study4_data, study4_kmeans)
    )
  
)
