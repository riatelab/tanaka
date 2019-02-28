library(raster)

rasto <- raster(x = "/home/tim/Téléchargements/GHS_POP_GPW42015_GLOBE_R2015A_54009_1k_v1_0/GHS_POP_GPW42015_GLOBE_R2015A_54009_1k_v1_0.tif")


library(cartography)
data(nuts2006)
m1 <- st_as_sf(nuts0.spdf)
m1 <- st_as_sf(nuts0.spdf)

m1 <- st_transform(x = m1, st_crs(rasto))
mx <- m1
m1 <- (m1[m1$id%in%c("FR", 'BE', 'DE',"LU", "CH"),])
m1$id
library(sf)
ras <- crop(x = rasto, y = m1)
library(rnaturalearth)


ctr <- (ne_countries(scale = 50,returnclass = "sf" )  )
mm <- st_transform(ctr, st_crs(m1))

plot(ras)
ras2 <- aggregate(ras, fact=7,fun=sum)
ras2 <- ras2/49

mat <- raster::focalWeight(x = ras, d = c(10000, 25000),type = "Gauss")
xx <- raster::focal(x = ras, w = mat, fun = sum,
                   na.rm = FALSE, pad = TRUE, padValue = 0)

plot(xx,
     col = carto.pal("wine.pal", 15))

getBreaks(v = c(1:9000), method = "geom")

bks <- getBreaks(v = values(xx)[values(xx)>1], nclass = 10, method = "geom")
bks <- c(0,50,100,250,500,1000,1500,2000,4000,8000,9000)
ras
par(mar = c(0,0,0,0))
bks <- c(0,50,100,250,500,1000,1500,2000,4000,8000,10000,20000, 100000000)
tanaka(xx, breaks = bks, shift = 1000, mask = mm, dark = "grey20",
       col = carto.pal("pink.pal", length(bks)-1))
plot(mm$geometry, add=T)

display.carto.all()


plot(m1$geometry, add=T)

(10000*10000) / (1000*1000)

library(linemap)
library(sf)
data("occitanie")
popOcc1 <- smoothgrid(x = popOcc, var = "pop", d = c(1000,5000), type = "Gauss")
opar <- par(mar=c(0,0,0,0), bg = "ivory2")
plot(st_geometry(occitanie), col="ivory1", border = NA)
linemap(x = popOcc1, var = "pop", k = 5, threshold = 25,
        col = "ivory1", border = "ivory4", lwd = 0.6, add = TRUE)
par(opar)
