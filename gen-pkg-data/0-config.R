# Configuration settings

library(ctv)
library(plyr)
library(jsonlite)

snapshot_url <- "file:///cran/.zfs/snapshot/2014-09-18"
snapshot_url <- "http://cran-snapshots.revolutionanalytics.com/2014-09-08_1746"

root_folder <- "packagedata"
json_folder <- "json"
graph_folder <- "graphs"
dep_plot_folder <- "plots"

allPackagesJson <- "allpackages.json"
allTaskviewJson <- "alltaskviews.json"

json_output <- file.path(root_folder, json_folder)
graph_output <- file.path(root_folder, graph_folder)

allPackagesJson <- file.path(json_output, allPackagesJson)
allTaskviewJson <- file.path(json_output, allTaskviewJson)



# check folders exist -----------------------------------------------------

if(!file.exists(json_output)) stop("json output folder doesn't exist")
if(!file.exists(graph_output)) stop("graph output folder doesn't exist")
