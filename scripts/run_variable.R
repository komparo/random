library(readr)
library(dplyr)
library(tibble)

# read parameters
parameters <- jsonlite::fromJSON(inputs[["parameters"]], simplifyVector = TRUE)
set.seed(parameters$seed)

# read gene_expression
gene_expression <- read.csv(inputs[["gene_expression"]], row.names = 1) %>% as.matrix()

# determine differentially expressed genes
feature_variability <- gene_expression %>% apply(2, sd) %>% enframe("feature_id", "sd")
tde_overall <- feature_variability %>% 
  arrange(desc(sd)) %>% 
  mutate(significant = row_number() <= ceiling(n() * parameters[["percentage_differentially_expressed"]])) %>% 
  select(-sd)

# write dataset
write_csv(tde_overall, outputs[["tde_overall"]])

# generate metadata
metadata <- list(
)
yaml::write_yaml(metadata, outputs[["meta"]])
