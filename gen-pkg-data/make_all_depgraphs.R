pkgs <- pkgAvail()

library(foreach)
library(iterators)
library(doParallel)

cl <- makeCluster(8)
registerDoParallel(cl)

res <- foreach(p=iter(rownames(pkgs)), .packages = "miniCRAN", .inorder = FALSE) %dopar% {
  makeDepGraph(p, availPkgs = pkgs)
}

saveRDS(res, file="allDepGraphs.rds")

plotOne <- function(i){
  plotName <- paste0(rownames(pkgs)[i], ".png")
  png(file.path("plots", plotName), width=800, height=600)
  plot(res[[i]])
  dev.off()
}

system.time({
  foreach(i=seq_along(res)) %do% plotOne(i)
})

length(res)

stopCluster(cl)
