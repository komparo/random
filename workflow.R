library(certigo)

# installed together with certigo
library(tidyr)
library(stringr)
library(dplyr)

method_design_all <- tibble(
  percentage_differentially_expressed = c(0, 0.25, 0.5, 0.75, 1),
  seed = 1
) %>% 
  transmute(parameters = dynutils::mapdf(., parameters)) %>% 
  mutate(id = as.character(seq_len(n())))

generate_method_calls <- function(datasets, method_design = method_design_all, workflow_folder = ".", models_folder = "models") {
  design <- crossing(
    datasets$design %>% select(dataset_id = id, expression),
    method_design
  ) %>% 
    mutate(
      script = list(script_file(str_glue("{workflow_folder}/scripts/run.R"))),
      executor = list(docker_executor("komparo/tde_method_random")),
      
      tde_overall = str_glue("{models_folder}/{id}/{dataset_id}/tde_overall.csv") %>% purrr::map(derived_file),
      meta = str_glue("{models_folder}/{id}/{dataset_id}/meta.yml") %>% purrr::map(derived_file)
    )
  
  rscript_call(
    "komparo/random",
    design = design,
    inputs = c("script", "executor", "parameters", "expression"),
    outputs = c("tde_overall", "meta")
  )
}
