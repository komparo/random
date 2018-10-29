library(certigo)

# installed together with certigo
library(tidyr)
library(stringr)
library(dplyr)

get_call <- function(datasets) {
  method_design <- tibble(
    percentage_differentially_expressed = c(0, 0.25, 0.5, 0.75, 1),
    seed = 1
  ) %>% 
    transmute(parameters = dynutils::mapdf(., parameters)) %>% 
    mutate(
      method_id = as.character(row_number())
    )
  
  design <- crossing(
    tibble(dataset = datasets$design %>% dynutils::mapdf(identity)),
    method_design
  ) %>% 
    mutate(
      script = list(script_file(str_glue("scripts/run.R"))),
      executor = list(docker_executor("komparo/tde_method_random")),
      
      tde_overall = str_glue("{method_id}/{map_chr(dataset, 'id')}/tde_overall.csv") %>% purrr::map(derived_file),
      meta = str_glue("{method_id}/{map_chr(dataset, 'id')}/meta.yml") %>% purrr::map(derived_file)
    )
  
  rscript_call(
    design = design,
    inputs = exprs(script, executor, parameters, expression = map(dataset, "expression")),
    outputs = exprs(tde_overall, meta)
  )
}
