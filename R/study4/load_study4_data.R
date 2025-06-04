# function to load data from study 4 and exclude attention check failures
load_study4_data <- function(study4_data_file) {
  read_csv(
    file = study4_data_file,
    show_col_types = FALSE
    ) %>%
    # correct attention check answer is 8
    filter(Attention_Check == 8)
}
