
# source("0-shared-scripts.R")
# source("0-config.R")


# Download taskviews from MRAN snapshot ----------------------------

views <- available.views(repos = snapshot_url)

# overview <- do.call(rbind, views)
# overview <- overview[, setdiff(colnames(overview), "packagelist")]

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
dim(overview)

# Export to json ----------------------------------------------------------
viewJson  <-  toJSON(list(data=overview), pretty=TRUE)
write(viewJson, file=allTaskviewJson)



# detail <- lapply(views, function(view){
#   with(view,
#        data.frame(
#          view=rep(name, nrow(packagelist)),
#          packagelist
#        )
#   )
# })


# views # List containing all information
# overview # matrix of top-level info
# detail # list of data frames for each taskview
