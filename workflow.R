library(tde)
library(certigo)

# installed together with certigo
library(tidyr)
library(stringr)
library(dplyr)

get_call <- function(datasets) {
  # Random ------------------------------------------------------------------
  method_design_random <- tibble(
    percentage_differentially_expressed = c(0, 0.25, 0.5, 0.75, 1),
    seed = 1
  ) %>% 
    transmute(parameters = dynutils::mapdf(., parameters)) %>% 
    mutate(
      method_id = paste0("random_", as.character(row_number()))
    )
  
  design_random <- crossing(
    tibble(dataset = datasets$design %>% dynutils::mapdf(identity)),
    method_design_random
  ) %>% 
    mutate(
      id = paste0(method_id, "/", map_chr(dataset, 'id')),
      
      script = list(script_file(str_glue("scripts/run_random.R"))),
      executor = list(docker_executor("komparo/tde_method_controls")),
      
      tde_overall = str_glue("{id}/tde_overall.csv") %>% purrr::map(tde_overall),
      meta = str_glue("{id}/meta.yml") %>% purrr::map(derived_file)
    )
  
  call_random <- rscript_call(
    design = design_random,
    inputs = exprs(script, executor, parameters, gene_expression = map(dataset, "gene_expression")),
    outputs = exprs(tde_overall, meta)
  )
  

  # Identity ----------------------------------------------------------------
  identity_design <- tibble(
      parameters = map(transpose(list(opposite = c(TRUE, FALSE))), certigo::parameters),
      method_id = c("identity", "opposite"),
      script = list(script_file(str_glue("scripts/run_identity.R")))
    )
  
  design_identity <- crossing(
    tibble(dataset = datasets$design %>% dynutils::mapdf(identity)),
    identity_design
  ) %>% 
    mutate(
      id = paste0(method_id, "/", map_chr(dataset, 'id')),
      
      script = list(script_file(str_glue("scripts/run_identity.R"))),
      executor = list(docker_executor("komparo/tde_method_random")),
      
      tde_overall = str_glue("{id}/tde_overall.csv") %>% purrr::map(derived_file),
      meta = str_glue("{id}/meta.yml") %>% purrr::map(derived_file)
    )
  
  call_identity <- rscript_call(
    design = design_identity,
    inputs = exprs(script, executor, parameters, tde_overall = map(dataset, "tde_overall")),
    outputs = exprs(tde_overall, meta)
  )
  
  # Most variable -------------------------------------------------------------
  method_design_variable <- tibble(
    percentage_differentially_expressed = c(0, 0.25, 0.5, 0.75, 1),
    seed = 1
  ) %>% 
    transmute(parameters = dynutils::mapdf(., parameters)) %>% 
    mutate(
      method_id = paste0("variable", as.character(row_number()))
    )
  
  design_variable <- crossing(
    tibble(dataset = datasets$design %>% dynutils::mapdf(identity)),
    method_design_variable
  ) %>% 
    mutate(
      id = paste0(method_id, "/", map_chr(dataset, 'id')),
      
      script = list(script_file(str_glue("scripts/run_variable.R"))),
      executor = list(docker_executor("komparo/tde_method_controls")),
      
      tde_overall = str_glue("{id}/tde_overall.csv") %>% purrr::map(derived_file),
      meta = str_glue("{id}/meta.yml") %>% purrr::map(derived_file)
    )
  
  call_variable <- rscript_call(
    design = design_variable,
    inputs = exprs(script, executor, parameters, gene_expression = map(dataset, "gene_expression")),
    outputs = exprs(tde_overall, meta)
  )
  
  call_collection("", call_random, call_identity, call_variable)
}
