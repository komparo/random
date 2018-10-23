source('workflow.R')

if (fs::dir_exists("modules")) fs::dir_delete("modules")
git2r::clone("https://github.com/komparo/tde_dataset_dyntoy", local_path = "modules/dataset")

source("modules/dataset/workflow.R")

datasets <- generate_dataset_calls(
  workflow_folder = "modules/dataset",
  datasets_folder = "results/datasets",
  dataset_design = dataset_design[1, ]
)

run_method <- generate_method_calls(
  method_design = method_design[1, ],
  datasets = datasets,
  models_folder = "results/models"
)

workflow <- workflow(
  list(
    datasets,
    run_method
  )
)

workflow$reset()
workflow$run()
