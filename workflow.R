library(certigo)

# installed together with certigo
library(tidyr)
library(stringr)
library(dplyr)

design <- tibble(
  percentage_differentially_expressed = c(0, 0.5, 1)
) %>% 
  mutate(run_id = as.character(seq_len(n())))

run_method_expression <- rlang::quo(rscript_call(
  "run_method",
  script_file(str_glue("{workflow_folder}/scripts/run.R")),
  inputs = lst(
    expression = derived_file(str_glue("{datasets_folder}/{dataset_id}/expression.csv"))
  ),
  outputs = list(
    tde_overall = derived_file(str_glue("{output_folder}/{dataset_id}/{run_id}/tde_overall.csv")),
    meta = derived_file(str_glue("{output_folder}/{dataset_id}/{run_id}/meta.yml"))
  ),
  design = design,
  params = params,
  executor = docker_executor("komparo/tde_method_random")
))
