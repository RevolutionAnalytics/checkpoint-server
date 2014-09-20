
source("0-config.R")

library(plyr)
library(jsonlite)
library(miniCRAN)


# Download package metadata from CRAN -------------------------------------

getPackagesFromRds <- function(pkgfile){
  dat <- as.data.frame(readRDS(pkgfile), stringsAsFactors = FALSE)
  dat[["Published"]] <- as.Date(dat[["Published"]])

  # remove duplicated MD5sums column
  dups <- which(names(dat) == "MD5sum")
  remove <- which.min(sapply(dat[, dups], function(x)length(na.omit(x))))
  dat[dups[remove]] <- NULL
  dat
}

getPackagesFromUrl <- function(repos = "http://cran.revolutionanalytics.com/",
                               pkg = "web/packages/packages.rds",
                               url = file.path(repos, pkg, fsep="/")){
  pkgfile <- tempfile(pattern = "packages", fileext = ".rds")
  on.exit(unlink(pkgfile))
  download.file(url, destfile = pkgfile, mode = "wb", quiet = TRUE)
  getPackagesFromRds(pkgfile)
}

getPackagesFromMRAN <- function(file="/cran/web/packages", rds="packages.rds"){
  pkgfile <- file.path(file, rds)
  getPackagesFromRds (pkgfile)
}


# Download CRAN taskview metadata from CRAN -------------------------------

getViewsFromUrl <- function(repos = "http://cran.revolutionanalytics.com/"){
  if(!require("plyr")) stop("package plyr not available")
  if(!require("ctv")) stop("package ctv not available")
  views <- available.views()
  v <- do.call(rbind, lapply(views, function(v){
    pkg <- v$packagelist
    pkg$view <- v$name
    pkg
  }))
  names(v) <- c("Package", "Core", "TaskView")
  ddply(v, .(Package), summarize, TaskView = paste(TaskView, collapse = ", "))
}

getViewsFromMRAN <- function(file="/cran/src/contrib", rds="Views.rds"){
  views <- readRDS(file.path(file, rds))
  v <- do.call(rbind, lapply(views, function(v){
    pkg <- v$packagelist
    pkg$view <- v$name
    pkg
  }))
  names(v) <- c("Package", "Core", "TaskView")
  ddply(v, .(Package), summarize, TaskView = paste(TaskView, collapse = ", "))
}


#===========================================================================


# Download packages from MRAN snapshot ------------------------------------

# pkgs <- getPackagesFromUrl(repos = snapshot_url)
# views <- getViewsFromUrl(repos = snapshot_url)
pkgs <- getPackagesFromMRAN()
views <- getViewsFromMRAN()


# Merge packages and views ------------------------------------------------

message("Merging packages and views")
mpkg <- merge(pkgs, views, all.x = TRUE, by = "Package")
mpkg[["Popularity"]] <- 0
mpkg[["Title"]] <- gsub("\n", " ", mpkg[["Title"]])
names(mpkg) <- gsub(" ", "_", names(mpkg))


# Create subset for all packages page -------------------------------------

apCols  <- c("Package", "Published", "Popularity", "Author", "Title", "TaskView")
if(!all(apCols %in% names(mpkg))) stop("Some columns not found")
apData <- mpkg[, apCols]


# Export overview data to json --------------------------------------------

message("Exporting json")
apJson  <-  toJSON(list(data=apData), pretty=TRUE)
write(apJson, file=allPackagesJson)




# Read vignette data ------------------------------------------------------

vign_short <- list.files(cran_uri, recursive=TRUE, pattern="index.rds", full.names = FALSE)
vign_long  <- list.files(cran_uri, recursive=TRUE, pattern="index.rds", full.names = TRUE)

parts <- strsplit(vign_short, split="/")
pkg_names <-  sapply(parts, "[[", 1)


rds_data <- lapply(vign_long, readRDS)

foo <- function(i, rds = rds_data[[i]]){
  data.frame(rds, stringsAsFactors = FALSE)
}

allVignettes <- lapply(seq_along(rds_data), foo)
names(allVignettes) <- pkg_names


# Export individual package files to json ---------------------------------

message("Exporting individual package json")

pkgsToInclude <- seq(nrow(mpkg))
for(i in pkgsToInclude){
  thisPackage <- mpkg[i, ]
  thisPackageName <- mpkg[i, "Package"]

  pkgJson <- if(thisPackageName %in% names(allVignettes)) {
    toJSON(list(data = thisPackage, vignettes = allVignettes[thisPackageName][[1]]), pretty=TRUE)
  } else {
    toJSON(list(data = thisPackage), pretty=TRUE)
  }
  write(pkgJson, file=file.path(json_output, paste0(apData$Package[i], ".json")))
}


# Download taskviews from MRAN snapshot ----------------------------


message("Creating taskview data")

# views <- available.views(repos = snapshot_url)
views <- getViewsFromMRAN()
overview <- do.call(rbind,
                    lapply(views, function(view){
                      with(view,
                           data.frame(
                             Updated = version,
                             Name    = name,
                             Topic   = topic,
                             Maintainer = maintainer,
                             Packages   = nrow(packagelist)
                           )
                      )
                    })
)

# Export to json ----------------------------------------------------------
viewJson  <-  toJSON(list(data=overview), pretty=TRUE)
write(viewJson, file=allTaskviewJson)




# To do -------------------------------------------------------------------

# Convert all package json file names to lower case

# Add json for base packages

library(miniCRAN)

baseJson  <-  toJSON(list(data=basePkgs()), pretty=TRUE)
write(baseJson, file=file.path(json_output, "base_packages.json"))

# Add vignettes to package json


# Add citation
# Add NEWS
#



message("All done")
