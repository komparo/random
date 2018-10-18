library(readr)
library(dplyr)

# read parameters
design <- jsonlite::fromJSON(inputs[["design"]])
set.seed(design$seed)

# read expression
expression <- read.csv(inputs[["expression"]], row.names = 1) %>% as.matrix()

# generate datasets
tde_overall <- tibble(
  feature_id = colnames(expression)
) %>% 
  mutate(
    tde_overall = runif(n()) <= design["percentage_differentially_expressed"]
  )

# write dataset
write_csv(tde_overall, outputs[["tde_overall"]])

# generate metadata
metadata <- list(
)
yaml::write_yaml(metadata, outputs[["meta"]])
