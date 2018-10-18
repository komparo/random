FROM rocker/tidyverse

RUN R -e 'devtools::install_github("dynverse/dyntoy")'
RUN R -e 'devtools::install_github("dynverse/dynwrap@devel", dep = F)'
RUN R -e 'devtools::install_github("dynverse/dyntoy@devel", dep = F)'