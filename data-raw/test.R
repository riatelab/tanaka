r1 <- readRDS("data-raw/mtq.rds")
m1 <- readRDS("data-raw/mask_mtq.rds")


tanaka(r1, mask = m1, light = "#ffffff70", dark = "#00000090", shift = 100)

library(elevatr)
df <- data.frame(x = c(1.6196,1.7427), y = c(44.8804,44.9502))
e75 <- get_elev_raster(df, z=12, prj = "+init=epsg:4326")
x <- rasToPoly(x = e75,breaks = seq(90,460,40))
tanaka(st_transform(x, 2154), light = "#ffffff70", dark = "#00000090", shift = 30)


plot(st_transform(river.geom, 2154), col = "blue", border = "lightblue", add=T)

plot(river$osm_polygons$geometry)

library(osmdata)
q <- opq(bbox = c(1.581171,44.777040,1.846567,44.965652 ),timeout = 180)
# Get the shape of the main river "La seine"
qr <- q %>%
  add_osm_feature (key = 'waterway',value = "riverbank")
river <- osmdata_sf(qr)
plot(river$osm_multipolygons$geometry)
river

library(dplyr)
river.geom <- st_geometry(river$osm_multipolygons %>% filter(name == "Lit de la Dordogne"))
head(river$osm_polygons)

# Export road and river layers to shapefile
st_write(roads.geom, dsn = "data/dep76/road.shp")
st_write(river.geom, dsn = "data/dep76/river.shp")
```

```{r , echo = FALSE}
roads.geom <- st_read(dsn = "data/dep76/road.shp", quiet = TRUE)
river.geom <- st_read(dsn = "data/dep76/river.shp", quiet = TRUE)
```
osmdata::



col = rev(c("#000004FF", "#170C3AFF", "#420A68FF", "#6B186EFF", "#932667FF",
                   "#BB3754FF", "#DD513AFF", "#F3771AFF", "#FCA50AFF", "#F6D645FF",
                   "#FCFFA4FF")))


par(mar = c(0,0,0,0), bg = "#B2DEF0")

xx <- rasToPoly()

tanaka(r1,nclass = 10,col = carto.pal("wine.pal", 10))

e1 <- st_bbox(x1)
e2 <- st_bbox(x2)
diff(e1[c(1,3)]) / 30
diff(e1[c(1,3)]) / (diff(e1[c(1,3)]) / 30)

diff(st_bbox(x)[c(1,3)]) / 600

diff(e1[3:4])*4.834036e-06


e2 <- st_bbox(x2)
diff(e2[1:2])   *  4.834036e-06

max()

plot(x1$geometry)
a <- grconvertX(c(0,0.007), from="inches", to="user")
diff(a)
b <- grconvertY(c(0,0.01), from="inches", to="user")
diff(b)
a <- grconvertX(c(0,30), from="user", to="ndc")

?grconvertX

par(fig = c(grconvertX(c(6000000,16000000), from="user", to="ndc"),
            grconvertY(c(-6600000,1500000), from="user", to="ndc")),
    mar = c(0,0,0,0),
    new = TRUE)

?grconvertX
layoutLayer
library()

plot(mtq)
xinch(.01)
