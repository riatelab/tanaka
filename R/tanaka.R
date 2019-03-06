#' @title Plot a Tanaka Map
#' @name tanaka
#' @description This function plots a tanaka map.
#' @param x a raster or an sf contour layer (e.g. the result of \code{tanaka_contour()}).
#' @param nclass a number of class.
#' @param breaks a list of breaks.
#' @param mask a mask layer, a POLYGON or MULTIPOLYGON sf object.
#' @param col a color palette (a vector of colors).
#' @param light light shadow (NW color).
#' @param dark dark shadow (SE color).
#' @param shift size of the shadow (in map units).
#' @param legend.pos  position of the legend, one of "topleft", "top",
#' "topright", "right", "bottomright", "bottom", "bottomleft", "left" or a
#' vector of two coordinates in map units (c(x, y)). If
#' legend.pos="n" then the legend is not plotted.
#' @param legend.title title of the legend.
#' @export
#' @import sf
#' @import isoband
#' @import raster
#' @importFrom grDevices colorRampPalette
#' @references Tanaka, K. (1950). The relief contour method of representing
#' topography on maps. \emph{Geographical Review, 40}(3), 444-456.
#' @return A Tanaka contour map is plotted.
#' @examples
#' library(tanaka)
#' library(raster)
#' library(sf)
#' com <- st_read(system.file("gpkg/com.gpkg", package = "tanaka"), quiet = TRUE)
#' ras <- raster(system.file("grd/elev.grd", package = "tanaka"))
#' tanaka(ras)
#' tanaka(ras, mask = com)
#' tanaka(ras, breaks = seq(80,400,20),
#'        legend.pos = "topright",
#'        legend.title = "Elevation\n(meters)")
tanaka <- function(x, nclass = 8, breaks, col, mask,
                   light = "#ffffff70", dark = "#00000090",
                   shift, legend.pos = "left", legend.title="Elevation"){
  if(methods::is(x, "RasterLayer")){
    x <- tanaka_contour(x = x, nclass = nclass, breaks = breaks, mask = mask)
  }
  nclass <- nrow(x)
  if(missing(col)){
    palet <- c("#FBDEE1", "#F7D2D6", "#F3C7CB", "#F0BCC0", "#ECB1B5", "#E9A6AB",
               "#E59BA0", "#E29095", "#DE858A", "#D9767B", "#D5676D", "#D0585E",
               "#CC4950", "#C73A41", "#BB2D34", "#9B262B", "#7C1E23", "#5C171A",
               "#3C0F11", "#1D0809")
    col <- colorRampPalette(palet)(nclass)
  }
  if(missing(shift)){shift <- diff(st_bbox(x)[c(1,3)]) / 700}
  x <- x[order(x$min),]
  plot(st_geometry(x), col = NA, border = NA)
  for(i in 1:nrow(x)){
    p <- st_geometry(x[i,])
    plot(p + c(-shift, shift), col = light, border = light, add = TRUE)
    plot(p + c(shift*5/3, -shift*5/3), col = dark, border = dark, add = TRUE)
    plot(p, col = col[i], border = "NA", add = TRUE)
  }
  legendtanaka(pos = legend.pos, breaks = c(x$min, max(x$max)), values.rnd = 0,
               col = col, title.txt = legend.title, cex = 0.8)
}

