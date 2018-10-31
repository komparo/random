library(readr)
library(dplyr)

# read parameters
parameters <- jsonlite::fromJSON(inputs[["parameters"]])
set.seed(parameters$seed)

# read gene_expression
gene_expression <- read.csv(inputs[["gene_expression"]], row.names = 1) %>% as.matrix()

# generate datasets
tde_overall <- tibble(
  feature_id = colnames(gene_expression)
) %>% 
  mutate(
    tde_overall = runif(n()) <= parameters["percentage_differentially_expressed"]
  )

# write dataset
write_csv(tde_overall, outputs[["tde_overall"]])

# generate metadata
metadata <- list(
)
yaml::write_yaml(metadata, outputs[["meta"]])
