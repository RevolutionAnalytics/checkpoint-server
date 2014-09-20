
library(foreach)
library(iterators)
library(doParallel)
library(miniCRAN)

# source("0-shared-scripts.R")
# source("0-config.R")


# Download packages from MRAN snapshot ------------------------------------

# pkgs <- getPackages(repos = snapshot_url)
pkgs <- getPackagesFromMRAN(cran = cran_uri)

# pkgs <- pkgs[1:16, ]   ###   <<<<<===== Remove this for production

cl <- makeCluster(4)
registerDoParallel(cl)

message("Creating dependency graphs")

res <- foreach(p=iter(rownames(pkgs)),
               .packages = "miniCRAN",
               .inorder = FALSE) %dopar% {
  makeDepGraph(p, availPkgs = pkgs)
}

saveRDS(res, file=file.path(pkg_output, "allDepGraphs.rds"))


message("Plotting dependency graphs")

plotOne <- function(i){
  plotName <- paste0(pkgs[, "Package"][i], ".png")
  png(file.path(graph_output, plotName), width=800, height=600)
  plot(res[[i]])
  dev.off()
}

system.time({
  foreach(i=seq_along(res)) %do% plotOne(i)
})


stopCluster(cl)

