# library(sf)
# com <- st_read("/home/tim/Téléchargements/ADMIN-EXPRESS-COG_1-1__SHP__FRA_2018-04-03/ADMIN-EXPRESS-COG/1_DONNEES_LIVRAISON_2018-03-28/ADE-COG_1-1_SHP_LAMB93_FR/COMMUNE_CARTO.shp")
# com46 <- com[com$INSEE_COM %in% c(46185,46106, 46330,46265, 46058, 46028, 46084,46208),]
# library(elevatr)
# ras0 <- get_elev_raster(com46, z=10)
# library(raster)
# ras0 <- crop(ras0, com46)
# writeRaster(x = ras0, filename = "inst/grd/elev.grd")
# st_write(com46, "inst/gpkg/com.gpkg", delete_dsn = T)


library(tanaka)
library(raster)
library(cartography)
library(sf)
library(elevatr)

com <- st_read(system.file("gpkg/com.gpkg", package = "tanaka"), quiet = TRUE)
ras <- raster(system.file("grd/elev.grd", package = "tanaka"))
ras <- crop(ras, extent(586101.7,603178.4, 6421500, 6428100))
iso <- tanaka_contour(ras, breaks = seq(80,400,20))
getFigDim(x = iso, width = 700, mar = c(0,0,0,0), res = 100)
png("img/banner.png", width = 700, height = 270, res =100, bg = NA)
par(mar = c(0,0,0,0))
tanaka(iso,legend.pos = "n")
dev.off()

com <- st_read(system.file("gpkg/com.gpkg", package = "tanaka"), quiet = TRUE)
ras <- raster(system.file("grd/elev.grd", package = "tanaka"))
png("img/ex1.png", width = 700, height = 533, res =100, bg = NA)
par(mar = c(0,0,0,0))
tanaka(ras, breaks = seq(80,400,20),
       legend.pos = "topright", legend.title = "Elevation\n(meters)")
dev.off()

# use elevatr to get elevation data
ras <- get_elev_raster(locations = data.frame(x = c(6.7, 7), y = c(45.8,46)),
                       z = 10, prj = "+init=epsg:4326", clip = "locations")
# custom color palette
cols <- c("#F7E1C6", "#EED4C1", "#E5C9BE", "#DCBEBA", "#D3B3B6", "#CAA8B3",
          "#C19CAF", "#B790AB", "#AC81A7", "#A073A1", "#95639D", "#885497",
          "#7C4692", "#6B3D86", "#573775", "#433266", "#2F2C56", "#1B2847")
png("img/ex2.png", width = 700, height = 533, res =100, bg = NA)
# display the map
par(mar=c(0,0,0,0))
tanaka(ras, breaks = seq(500,4800,250), col = cols)
dev.off()
