# Determine script path and set working directory
args <- commandArgs(trailingOnly = FALSE)
scriptPath <- normalizePath(dirname(sub("^--file=", "", args[grep("^--file=", args)])))
setwd(scriptPath)

source("0-config.R")
source("0-common-scripts.R")
source("1-pkg-view-vignette.R")
source("2-taskviews.R")
# source("3-depgraphs.R")
source("4-fast-depgraphs.R")
message("All done")
