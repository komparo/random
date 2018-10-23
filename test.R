source('workflow.R')

dataset_design <- tibble(
  id = "1"
)

datasets <- rscript_call(
  "datasets/dummy",
  design = dataset_design,
  inputs = list(
    script = script_file("scripts/generate_test_data.R")
  ),
  outputs = dataset_design %>% transmute(
    expression = str_glue("datasets/{id}/expression.csv") %>% purrr::map(derived_file)
  )
)

run_method <- generate_method_calls(
  method_design = method_design[1, ],
  datasets = datasets
)

workflow <- workflow(
  list(
    datasets,
    run_method
  )
)

workflow$reset()
workflow$run()
