rm(list=ls())

require(knitr)


# ---- folders ----
script.folder <- "~/Documents/workflows/Brain_size_evolution/"
report.folder <- "~/Google Drive/Brain evolution/outputs/reports/"



purl(input = paste(script.folder, "match_workflow.Rmd", sep = ""))

rmarkdown::render(paste(script.folder, "match_workflow.Rmd", sep = ""), 
                  output_format = "html_notebook")
