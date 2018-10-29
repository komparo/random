library(readr)
library(dplyr)

# read tde_overall
tde_overall <- read_csv(inputs[["tde_overall"]])

parameters <- jsonlite::read_json(inputs[["parameters"]], simplifyVector = TRUE)
if (parameters[["opposite"]]) {
  tde_overall$tde_overall <- !tde_overall$tde_overall
}

# write dataset
write_csv(tde_overall, outputs[["tde_overall"]])

# generate metadata
metadata <- list(
)
yaml::write_yaml(metadata, outputs[["meta"]])
