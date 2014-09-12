library(ctv)
library(plyr)
library(jsonlite)


# Download package metadata from CRAN -------------------------------------

getPackages <- function(repos = "http://cran.revolutionanalytics.com/",
                        pkg = "web/packages/packages.rds",
                        url = file.path(repos, pkg, fsep="/")){
  pkgfile <- tempfile(pattern = "packages", fileext = ".rds")
  on.exit(unlink(pkgfile))
  download.file(url, destfile = pkgfile, mode = "wb", quiet = TRUE)
  dat <- as.data.frame(readRDS(pkgfile), stringsAsFactors = FALSE)
  dat[["Published"]] <- as.Date(dat[["Published"]])

  # remove duplicated MD5sums column
  dups <- which(names(dat) == "MD5sum")
  remove <- which.min(sapply(dat[, dups], function(x)length(na.omit(x))))
  dat[dups[remove]] <- NULL
  dat
}



# Download CRAN taskview metadata from CRAN -------------------------------

getViews <- function(repos = "http://cran.revolutionanalytics.com/"){
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
