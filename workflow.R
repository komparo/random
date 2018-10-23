library(certigo)

# installed together with certigo
library(tidyr)
library(stringr)
library(dplyr)

method_id <- "komparo/random"

method_design <- tibble(
  percentage_differentially_expressed = c(0, 0.25, 0.5, 0.75, 1),
  seed = 1
) %>% 
  transmute(parameters = dynutils::mapdf(., parameters)) %>% 
  mutate(id = as.character(seq_len(n())))

run_method_expression <- rlang::quo({
  design <- crossing(
    datasets$design %>% setNames(paste0("dataset_", names(.))) %>% bind_cols(datasets$outputs),
    method_design
  )
  
  rscript_call(
    "run",
    inputs = design %>% 
      select(expression, parameters) %>% 
      mutate(
        script = list(script_file(str_glue("{workflow_folder}/scripts/run.R"))),
        executor = list(docker_executor("komparo/tde_method_random"))
    ),
    outputs = design %>% transmute(
      tde_overall = str_glue("{models_folder}/{id}/{dataset_id}/tde_overall.csv") %>% purrr::map(derived_file),
      meta = str_glue("{models_folder}/{id}/{dataset_id}/meta.yml") %>% purrr::map(derived_file)
    )
  )
})

