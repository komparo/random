library(certigo)

datasets <- load_call_git(
  "https://github.com/komparo/tde_dataset_dyntoy",
  derived_file_directory = "results/datasets"
)
datasets$design <- datasets$design[1, ]

method <- load_call(
  "workflow.R", 
  derived_file_directory = "results/models",
  datasets = datasets
)
method$design <- method$design

workflow <- workflow(
  datasets,
  method
)

workflow$reset()
workflow$run()
