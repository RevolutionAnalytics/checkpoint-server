

library(plyr)
library(jsonlite)
library(miniCRAN)






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

message("Reading vignette data")

vign_short <- list.files(cran_uri, recursive=TRUE, pattern="index.rds", full.names = FALSE)
vign_long  <- list.files(cran_uri, recursive=TRUE, pattern="index.rds", full.names = TRUE)

parts <- strsplit(vign_short, split="/")
pkg_names <-  sapply(parts, "[[", 3)   ### <- web / packages / pkgname / ...


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






# To do -------------------------------------------------------------------

# Convert all package json file names to lower case

# Add json for base packages

library(miniCRAN)

baseJson  <-  toJSON(list(data=basePkgs()), pretty=TRUE)
write(baseJson, file = basePackagesJson)

# Add vignettes to package json


# Add citation
# Add NEWS
#



message("All done")
