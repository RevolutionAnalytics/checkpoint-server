
library(foreach)
library(iterators)
library(doParallel)
library(miniCRAN)

# source("0-shared-scripts.R")
# source("0-config.R")


# Download packages from MRAN snapshot ------------------------------------

pkgs <- readRDS(paste0(cran_uri, "web/packages/packages.rds"))
saveRDS(pkgs, file.path(pkg_output, "packages.rds"))
rownames(pkgs) <- pkgs[, "Package"]


# pkgs <- pkgs[1000:1100, ]   ###   <<<<<===== Remove this for production

cl <- makeCluster(numCoresToUse)
registerDoParallel(cl)

message("Creating and plotting dependency graphs")

time <- system.time({
  res <- foreach(p=iter(rownames(pkgs)),
                 .packages = "miniCRAN",
                 .inorder = FALSE) %dopar% {
                   dp <- makeDepGraph(p, availPkgs = pkgs, suggests=TRUE, enhances = TRUE)
                   plotName <- paste0(pkgs[, "Package"][p], ".png")
                   png(file.path(graph_output, plotName), width=730, height=560)
                   plot(dp, vertex.size=15)
                   dev.off()
                   dp

                 }
})

stopCluster(cl)

saveRDS(res, file=file.path(pkg_output, "allDepGraphs.rds"))

message("Time to create dependency graphs: ", time[3])
