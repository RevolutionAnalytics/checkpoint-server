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

# getPackagesFromUrl <- function(repos = "http://cran.revolutionanalytics.com/",
#                                pkg = "web/packages/packages.rds",
#                                url = file.path(repos, pkg, fsep="/")){
#   pkgfile <- tempfile(pattern = "packages", fileext = ".rds")
#   on.exit(unlink(pkgfile))
#   download.file(url, destfile = pkgfile, mode = "wb", quiet = TRUE)
#   getPackagesFromRds(pkgfile)
# }

getPackagesFromMRAN <- function(cran="/cran/", rds="web/packages/packages.rds"){
  pkgfile <- file.path(cran, rds)
  getPackagesFromRds (pkgfile)
}


#==========================================================================

# Download CRAN taskview metadata from CRAN -------------------------------

# getViewsFromUrl <- function(repos = "http://cran.revolutionanalytics.com/"){
#   if(!require("plyr")) stop("package plyr not available")
#   if(!require("ctv")) stop("package ctv not available")
#   views <- available.views()
#   v <- do.call(rbind, lapply(views, function(v){
#     pkg <- v$packagelist
#     pkg$view <- v$name
#     pkg
#   }))
#   names(v) <- c("Package", "Core", "TaskView")
#   ddply(v, .(Package), summarize, TaskView = paste(TaskView, collapse = ", "))
# }

MRANview <- function(repos="/cran/"){
  contriburl <- paste(repos, "src/contrib", sep = "")
  rval <- list()
  for (i in seq(along.with = contriburl)) {
    viewurl <- paste(contriburl[i], "Views.rds", sep = "/")
    x <- suppressWarnings(try(readRDS(viewurl), silent = TRUE))
    for (j in seq(along = x)) x[[j]]$repository <- repos[i]
    rval <- c(rval, x)
  }
  class(rval) <- "ctvlist"
  return(rval)
}



getViewsFromMRAN <- function(cran="/cran/", rds="src/contrib/Views.rds"){
  views <- MRANview(cran)
  v <- do.call(rbind, lapply(views, function(v){
    pkg <- v$packagelist
    pkg$view <- v$name
    pkg
  }))
  names(v) <- c("Package", "Core", "TaskView")
  ddply(v, .(Package), summarize, TaskView = paste(TaskView, collapse = ", "))
}
