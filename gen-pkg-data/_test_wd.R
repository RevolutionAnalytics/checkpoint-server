args <- commandArgs(trailingOnly = FALSE)
scriptPath <- normalizePath(dirname(sub("^--file=", "", args[grep("^--file=", args)])))
setwd(scriptPath)
message(getwd())
