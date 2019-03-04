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
library(sf)
com <- st_read(system.file("gpkg/com.gpkg", package = "tanaka"), quiet = TRUE)
ras <- raster(system.file("grd/elev.grd", package = "tanaka"))
tanaka(ras)



library(tanaka)
library(elevatr)
library(raster)
# use elevatr to get elevation data
ras0 <- get_elev_raster(
  locations = data.frame(x = c(6.7, 7),
                         y = c(45.8,48)),
  z = 10,
  prj = "+init=epsg:4326"
)
ras <- crop(ras0, y = extent(c(6.7, 7, 45.8 ,46)))
# display the map
cols <- c("#F7E1C6", "#EED4C1", "#E5C9BE", "#DCBEBA", "#D3B3B6", "#CAA8B3",
          "#C19CAF", "#B790AB", "#AC81A7", "#A073A1", "#95639D", "#885497",
          "#7C4692", "#6B3D86", "#573775", "#433266", "#2F2C56", "#1B2847")
tanaka(ras, breaks = seq(500,4800,250), col = cols)




, col = rev(c("#000004FF", "#090720FF", "#1A1042FF", "#311165FF", "#4A1079FF",
                                                "#621980FF", "#792282FF", "#912B81FF", "#AA337DFF", "#C23B75FF",
                                                "#D9466BFF", "#EC5860FF", "#F7725CFF", "#FC8E64FF", "#FEAA74FF",
                                                "#FEC68AFF", "#FDE2A3FF", "#FCFDBFFF")))
dput(viridis::magma(18))
r <- raster()
extent(r)
extent(c(0, 20, 0, 20))

?get_elev_raster
ras

46.2309/6.4492
/46.2577/6.5130
palet <- c("#FBDEE1", "#F7D2D6", "#F3C7CB", "#F0BCC0", "#ECB1B5", "#E9A6AB",
           "#E59BA0", "#E29095", "#DE858A", "#D9767B", "#D5676D", "#D0585E",
           "#CC4950", "#C73A41", "#BB2D34", "#9B262B", "#7C1E23", "#5C171A",
           "#3C0F11", "#1D0809")
col <- colorRampPalette(palet)(8)
dput(col)

library(tanaka)
library(raster)
library(sf)
com <- st_read(system.file("gpkg/com.gpkg", package = "tanaka"), quiet = TRUE)
ras <- raster(system.file("grd/elev.grd", package = "tanaka"))
tanaka(ras)
tanaka(ras, mask = com)
par(mar=c(0,0,0,0))
tanaka(ras, breaks = seq(80,400,20),
       legend.pos = "n",
       legend.title = "Elevation\n(meters)")

library(cartography)
iso <- tanaka_contour(ras, breaks = seq(80,400,20))
getFigDim(x = iso, width = 800, mar = c(0,0,0,0), res = 200)
png("img/tanaka.png", width = 800, height = 713, res =100, bg = NA)
par(mar = c(0,0,0,0))
tanaka(iso,legend.pos = "n")
dev.off()


# iso <- rasToPoly(x = ras)
# iso <- rasToPoly(x = ras, mask = com)
# iso <- rasToPoly(x = ras, mask = com, breaks = seq(80,400,5))
# x <- rasToPoly(x = ras, breaks = seq(80,420,30), mask = com)
# rasToPoly(x = ras, breaks = seq(80,420,30), mask = com)
#
# ?st_intersection
# plot(iso)
# is(st_geometry(iso), "sfc_GEOMETRY")
# class(iso$geometry[1])
# ?sf
#
# tanaka_contour(ras)
# ?contour
# plot(com46$geometry, add=T, col = "blue")
# par(mar = c(0,0,0,0))
# tanaka(x = ras,  breaks = seq(80,360,20), mask = com)
# plot(com$geom, add=T, border = "red", lwd = 2)
#
# mapview::mapview(com46)
#
# dput(viridis::magma(10))
# x <- rasToPoly(x = e75,breaks = seq(90,460,40))
# tanaka(st_transform(x, 2154), light = "#ffffff70", dark = "#00000090", shift = 30)
#
#
# plot(st_transform(river.geom, 2154), col = "blue", border = "lightblue", add=T)
#
# plot(river$osm_polygons$geometry)
#
# library(osmdata)
# q <- opq(bbox = c(1.581171,44.777040,1.846567,44.965652 ),timeout = 180)
# # Get the shape of the main river "La seine"
# qr <- q %>%
#   add_osm_feature (key = 'waterway',value = "riverbank")
# river <- osmdata_sf(qr)
# plot(river$osm_multipolygons$geometry)
# river
#
# library(dplyr)
# river.geom <- st_geometry(river$osm_multipolygons %>% filter(name == "Lit de la Dordogne"))
# head(river$osm_polygons)
#
# # Export road and river layers to shapefile
# st_write(roads.geom, dsn = "data/dep76/road.shp")
# st_write(river.geom, dsn = "data/dep76/river.shp")
# ```
#
# ```{r , echo = FALSE}
# roads.geom <- st_read(dsn = "data/dep76/road.shp", quiet = TRUE)
# river.geom <- st_read(dsn = "data/dep76/river.shp", quiet = TRUE)
# ```
# osmdata::
#
#
#
# col = rev(c("#000004FF", "#170C3AFF", "#420A68FF", "#6B186EFF", "#932667FF",
#                    "#BB3754FF", "#DD513AFF", "#F3771AFF", "#FCA50AFF", "#F6D645FF",
#                    "#FCFFA4FF")))
#
#
# par(mar = c(0,0,0,0), bg = "#B2DEF0")
#
# xx <- rasToPoly()
#
# tanaka(r1,nclass = 10,col = carto.pal("wine.pal", 10))
#
# e1 <- st_bbox(x1)
# e2 <- st_bbox(x2)
# diff(e1[c(1,3)]) / 30
# diff(e1[c(1,3)]) / (diff(e1[c(1,3)]) / 30)
#
# diff(st_bbox(x)[c(1,3)]) / 600
#
# diff(e1[3:4])*4.834036e-06
#
#
# e2 <- st_bbox(x2)
# diff(e2[1:2])   *  4.834036e-06
#
# max()
#
# plot(x1$geometry)
# a <- grconvertX(c(0,0.007), from="inches", to="user")
# diff(a)
# b <- grconvertY(c(0,0.01), from="inches", to="user")
# diff(b)
# a <- grconvertX(c(0,30), from="user", to="ndc")
#
# ?grconvertX
#
# par(fig = c(grconvertX(c(6000000,16000000), from="user", to="ndc"),
#             grconvertY(c(-6600000,1500000), from="user", to="ndc")),
#     mar = c(0,0,0,0),
#     new = TRUE)
#
# ?grconvertX
# layoutLayer
# library()
#
# plot(mtq)
# xinch(.01)
