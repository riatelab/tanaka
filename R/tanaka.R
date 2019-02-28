#' @title Tanaka Map
#' @name tanaka
#' @description Plot a tanaka map.
#' @param x a raster or an sf contour layer.
#' @param nclass number of class.
#' @param breaks list of breaks.
#' @param col a color palette (a vector of colors).
#' @param mask a mask layer, sf object.
#' @param light light shadow (NW color)
#' @param dark dark shadow (SE color)
#' @param shift size of the shadow (in map units)
#' @export
#' @import sf
#' @import isoband
#' @import raster
#' @import cartography
tanaka <- function(x, nclass = 8, breaks, col, mask,
                   light = "grey95", dark = "grey5",
                   shift){
  if(methods::is(x, "RasterLayer")){
    x <- rasToPoly(x = x, nclass = nclass, breaks = breaks, mask = mask)
  }
  nclass <- nrow(x)
  if(missing(col)){col <- carto.pal("wine.pal", nclass)}
  if(missing(shift)){shift <- diff(st_bbox(x)[c(1,3)]) / 700}
  x <- x[order(x$min),]
  plot(st_geometry(x), col = NA, border = NA)
  for(i in 1:nrow(x)){
    p <- st_geometry(x[i,])
    plot(p + c(-shift, shift), col = light, border = light, add = TRUE)
    plot(p + c(shift*5/3, -shift*5/3), col = dark, border = dark, add = TRUE)
    plot(p, col = col[i], border = "NA", add = TRUE)
  }
  legendChoro(pos = "left", breaks = c(x$min, max(x$max)),
              col = col, nodata = F, title.txt = "Legend", cex = 0.8)
}
