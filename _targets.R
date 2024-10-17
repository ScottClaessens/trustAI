options(tidyverse.quiet = TRUE)
library(targets)
library(tarchetypes)
library(tidyverse)

# set options for targets and source R functions
tar_option_set(packages = c("brms", "tidyverse"))
tar_source()

# targets pipeline
list(
  # data file
  tar_target(data_file, "data/pilot/pilot_data_clean.csv", format = "file"),
  # load data
  tar_target(data, read_csv(data_file, show_col_types = FALSE)),
  # loop over two measures
  tar_map(
    values = tibble(measure = c("Felicity", "Sense")),
    # fit model
    tar_target(fit, fit_model(data, measure)),
    # extract category means
    tar_target(category_means, extract_category_means(fit)),
    # extract item means
    tar_target(item_means, extract_item_means(fit)),
    # plot categories
    tar_target(plot_category, plot_categories(data, measure, category_means)),
    # plot items
    tar_target(plot_item, plot_items(data, measure, item_means)),
    # plot category differences
    tar_target(plot_diff, plot_category_differences(category_means, measure))
  )
)
