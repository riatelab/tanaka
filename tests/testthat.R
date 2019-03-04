library(testthat)
library(tanaka)
library(raster)
library(sf)

com <- st_read(system.file("gpkg/com.gpkg", package = "tanaka"), quiet = TRUE)
ras <- raster(system.file("grd/elev.grd", package = "tanaka"))
iso <- tanaka_contour(x = ras, breaks = seq(80,420,50), mask = com)

test_check("tanaka")
