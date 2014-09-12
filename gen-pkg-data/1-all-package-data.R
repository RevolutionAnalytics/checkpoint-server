
source("0-shared-scripts.R")
source("0-config.R")


# Download packages from MRAN snapshot ------------------------------------

pkgs <- getPackages(repos = snapshot_url)
views <- getViews(repos = snapshot_url)

# Merge packages and views ------------------------------------------------

message("Merging packages and views")
mpkg <- merge(pkgs, views, all.x = TRUE, by = "Package")
mpkg[["Popularity"]] <- 0
mpkg[["Title"]] <- gsub("\n", " ", mpkg[["Title"]])


# Create subset for all packages page -------------------------------------

apCols  <- c("Package", "Published", "Popularity", "Author", "Title", "TaskView")
if(!all(apCols %in% names(mpkg))) stop("Some columns not found")
apData <- mpkg[, apCols]


# Export overview data to json --------------------------------------------

message("Exporting json")
apJson  <-  toJSON(apData, pretty=TRUE)
write(apJson, file=allPackagesJson)


# Export individual package files to json ---------------------------------

message("Exporting individual package json")
for(i in seq(nrow(mpkg))){
  pkgJson <- toJSON(mpkg[i, ], pretty=TRUE)
  write(pkgJson, file=file.path(json_output, paste0(apData$Package[i], ".json")))
}

message("All done")
