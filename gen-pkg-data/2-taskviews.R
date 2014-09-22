# source("0-config.R")

# Creating taskview data --------------------------------------------------

message("Creating taskview data")

# views <- available.views(repos = snapshot_url)
views <- MRANview()


foo <- function(view){
  data.frame(
    Updated = view$version,
    Name    = view$name,
    Topic   = view$topic,
    Maintainer = view$maintainer,
    Packages   = nrow(view$packagelist),
    stringsAsFactors = FALSE
  )
}

overview <- do.call(rbind, lapply(views, foo))

# Export to json ----------------------------------------------------------
viewJson  <-  toJSON(list(data=overview), pretty=TRUE)
write(viewJson, file=allTaskviewJson)
