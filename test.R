source('workflow.R')

call <- rscript_call(
  "generate_test_data",
  script = script_file("scripts/generate_test_data.R"),
  outputs = list(expression = derived_file("test_data/expression.csv"))
)
call$start_and_wait()

call <- rlang::eval_tidy(
  run_method_expression,
  data = list(
    design = design[1, ],
    params = list(workflow_folder = ".", datasets_folder = ".", dataset_id = "test_data", output_folder = "./models")
  )
)
call$start_and_wait()
