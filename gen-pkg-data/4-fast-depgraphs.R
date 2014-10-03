library(miniCRAN)
library(igraph)
library(foreach)
library(iterators)


# Download packages from MRAN snapshot ------------------------------------

local <- .Platform$OS.type == "windows"
test <- FALSE

if(local){
  source("0-config.R")
  pdb <- available.packages()
} else {
  pdb <- paste0(cran_uri, "web/packages/packages.rds")
  if(!file.exists(pdb)) stop("Unable to find package database")
  pdb <- readRDS(pdb)
}
if(nrow(pdb) == 0) stop("Unable to find package database")
rownames(pdb) <- pdb[, "Package"]

message("Creating dependency graph")
tm <- system.time({
  g <- makeDepGraph(unname(pdb[, "Package"]), availPkgs = pdb)
})
message("Time to compute: ", tm[3])

se <- which(E(g)$type %in% c("Suggests", "Enhances"))
g2 <- delete.edges(g, se)


extractPkgGraph <- function(g, pkg){

  nn <- which(V(g)$name == pkg)
  notSE <- unname(unlist(g[[,nn]]))
  numVertices <- length(vertex.attributes(g)[[1]])

  if(length(notSE) > 0){
    gg <- neighborhood(g2, order = 100, nodes = notSE, mode = "in")[[1]]
  } else {
    gg <- character(0)
  }
  ret <- delete.vertices(g, setdiff(seq_len(numVertices), c(nn, notSE, gg)))
  class(ret) <- c("pkgDepGraph", "igraph")
  attr(ret, "pkgs") <- pkg
  ret
}


if(test) pdb <- pdb[1000:1200, ]   ###   <<<<<===== Remove this for production

message("Plotting dependency graphs")

prevRds <- file.path(pkg_output, "allDepGraphs.rds")
prevAllDepGraphs <- if(file.exists(prevRds)) readRDS(prevRds) else NA


plotOneGraph <- function(dp, plotName){
  png(plotName, width=730, height=560)
  set.seed(1)
  plot(dp, vertex.size=15)
  dev.off()
  NULL
}

plotGraphIfChanged <- function(p, previous){
  recreate <- FALSE
  dp <- extractPkgGraph(g, pkg=p)
  if(!is.list(previous)) {
    recreate <- TRUE
  } else {
    if(!identical(unname(previous[p])[[1]], dp)) recreate <- TRUE
  }

  plotName <- file.path(graph_output, paste0(pdb[, "Package"][p], ".png"))

  if(!file.exists(plotName)) recreate <- TRUE
  if(recreate) {
    message(paste0("- ", p))
    plotOneGraph(dp, plotName)
  }
  dp
}

time <- system.time({
  res <- foreach(p=iter(rownames(pdb)),
                 .packages = "miniCRAN",
                 .inorder = FALSE) %do% {
                   plotGraphIfChanged(p, prevAllDepGraphs)
                 }
  names(res) <- rownames(pdb)
})

saveRDS(res, file=file.path(pkg_output, "allDepGraphs.rds"))

message("Time to plot dependency graphs: ", time[3])
