# Configuration settings

suppressPackageStartupMessages({
  library(ctv)
  library(plyr)
  library(jsonlite)
  library(miniCRAN)
})


cran_uri <- "/cran/"

cran_packages_uri <- "/cran/uri/web/packages/"
packages_rds <- "/cran/web/packages/packages.rds"

pkg_output   <- "../packagedata"
json_output  <- "../packagedata/json"
graph_output <- "../packagedata/graphs"

allPackagesJson  <- "../packagedata/allpackages.json"
basePackagesJson <- "../packagedata/basepackages.json"
allTaskviewJson  <- "../packagedata/alltaskviews.json"





# check folders exist -----------------------------------------------------

if(!file.exists(json_output)) stop("json output folder doesn't exist")
if(!file.exists(graph_output)) stop("graph output folder doesn't exist")


# snapshot_url <- "file:///cran/.zfs/snapshot/2014-09-18"
# snapshot_url <- "http://cran-snapshots.revolutionanalytics.com/2014-09-08_1746"
