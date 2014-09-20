

source("0-config.R")
source("0-common-scripts.R")

unlink(file.path(pkg_output, "*"))
unlink(file.path(json_output, "*"))
unlink(file.path(graph_output, "*"))


# source("1-pkg-view-vignette.R")
# source("2-taskviews.R")

source("3-depgraphs.R")

message("All done")


message("\n\n\nResults:\n")

list.files(pkg_output, recursive = FALSE)

message("\nIn json folder:\n")
x <- list.files(json_output, recursive = FALSE)
message(length(x))

message("\nIn graph folder:\n")
x <- list.files(graph_output, recursive = FALSE)
message(length(x))
