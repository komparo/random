source('workflow.R')

dataset_design <- tibble(
  id = "1"
)

datasets <- rscript_call(
  "generate_test_data",
  design = dataset_design,
  inputs = list(
    script = script_file("scripts/generate_test_data.R")
  ),
  outputs = dataset_design %>% transmute(
    expression = str_glue("test_data/{id}/expression.csv") %>% purrr::map(derived_file)
  )
)

run_method <- rlang::eval_tidy(
  run_method_expression,
  data = list(
    method_design = method_design[1, ],
    workflow_folder = ".",
    datasets_folder = "./test_data",
    models_folder = "./models",
    datasets = datasets
  )
)

workflow <- workflow(
  list(
    datasets,
    run_method
  )
)

workflow$reset()
workflow$run()
