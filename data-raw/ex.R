library(sf)
library(spatstat)
library(sp)
library(maptools)
library(raster)
library(cartography)
library(SpatialPosition)

## import dataset
feat <- sf::st_read("https://gist.githubusercontent.com/rCarto/747164575e3f216a123c3092d0ce9162/raw/f12390464f255b5f9760c577ab6bf5456cf61a40/iris75.geojson")
# Use french projection
feat <- sf::st_transform(feat, 2154)

## Compute density raster
# from sf to sp
feat <- as(feat,'Spatial')
plot(feat)
# get coodinates
coords <- coordinates(feat)
# from sp to spatstat
pts <- ppp(x = coords[,1], y = coords[,2], window = as.owin(feat, 10),
           marks = feat$P14_POP)
# compute density
ds <- density.ppp(x = pts, sigma = 300, eps = 100, weights = pts$marks)
# spatstat to raster, in inhab per sq. km
ras <- raster(ds, crs = proj4string(feat)) * 1000 * 1000
ras[is.na(ras)] <- 0
feat <- st_as_sf(feat)
saveRDS(ras, "paris.rds")
saveRDS(feat, "mask_paris.rds")


mtq <- st_read(system.file("gpkg/mtq.gpkg", package="cartography"))
# use WGS84 proj
mtq_latlon <- st_transform(mtq, 4326)
# import raster
ras <- raster("srtm_24_10.tif")
# crop on martinique area
mtq_ras <- crop(ras, st_bbox(mtq_latlon)[c(1,3,2,4)])
# aggregate the raster
mtq_ras <- aggregate(mtq_ras, fact=4,fun=mean)
mtq_ras <- projectRaster(mtq_ras, crs = "+proj=utm +zone=20 +datum=WGS84 +units=m +no_defs")

saveRDS(mtq_ras, "mtq.rds")
saveRDS(mtq, "mask_mtq.rds")






