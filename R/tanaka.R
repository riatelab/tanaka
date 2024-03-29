#' @title Plot a Tanaka Map
#' @name tanaka
#' @description This function plots a tanaka map.
#' @param x a raster or an sf contour layer (e.g. the result of
#' \code{tanaka_contour()}, "min" and "max" columns are needed).
#' @param nclass a number of class.
#' @param breaks a vector of break values.
#' @param mask a mask layer, a POLYGON or MULTIPOLYGON sf object.
#' @param col a color palette (a vector of colors).
#' @param light light shadow (NW color).
#' @param dark dark shadow (SE color).
#' @param shift size of the shadow (in map units).
#' @param legend.pos position of the legend, one of 'topleft', 'top',
#' 'topright', 'right', 'bottomright', 'bottom', 'bottomleft',
#' 'left' or a vector of two coordinates in map units (c(x, y)).
#' If leg.position = NA then the legend is not plotted.
#' If leg.position = 'interactive' click on the map to choose the
#' legend position.
#' @param legend.title title of the legend.
#' @param add whether to add the layer to an existing plot (TRUE) or
#' not (FALSE).
#' @export
#' @importFrom sf st_geometry st_bbox
#' @importFrom grDevices colorRampPalette
#' @importFrom graphics plot
#' @importFrom terra crs
#' @importFrom maplegend leg
#' @references Tanaka, K. (1950). The relief contour method of representing
#' topography on maps. \emph{Geographical Review, 40}(3), 444-456.
#' @return A Tanaka contour map is plotted.
#' @examples
#' library(tanaka)
#' library(terra)
#' library(sf)
#' com <- st_read(system.file("gpkg/com.gpkg", package = "tanaka"),
#'   quiet = TRUE
#' )
#' ras <- rast(system.file("tif/elev.tif", package = "tanaka"))
#' tanaka(ras)
#' tanaka(ras, mask = com)
#' tanaka(ras,
#'   breaks = seq(80, 400, 20),
#'   legend.pos = "topright",
#'   legend.title = "Elevation\n(meters)"
#' )
#' tanaka(ras,
#'   nclass = 15,
#'   col = hcl.colors(15, "YlOrRd"),
#'   legend.pos = "topright",
#'   legend.title = "Elevation\n(meters)"
#' )
tanaka <- function(x,
                   nclass = 8,
                   breaks,
                   col,
                   mask,
                   light = "#ffffff70",
                   dark = "#00000090",
                   shift,
                   legend.pos = "left",
                   legend.title = "Elevation",
                   add = FALSE) {
  if (inherits(x = x, what = "SpatRaster")) {
    x <-
      tanaka_contour(
        x = x,
        nclass = nclass,
        breaks = breaks,
        mask = mask
      )
  }
  nclass <- nrow(x)
  if (missing(col)) {
    palet <-
      c(
        "#FBDEE1",
        "#F7D2D6",
        "#F3C7CB",
        "#F0BCC0",
        "#ECB1B5",
        "#E9A6AB",
        "#E59BA0",
        "#E29095",
        "#DE858A",
        "#D9767B",
        "#D5676D",
        "#D0585E",
        "#CC4950",
        "#C73A41",
        "#BB2D34",
        "#9B262B",
        "#7C1E23",
        "#5C171A",
        "#3C0F11",
        "#1D0809"
      )
    col <- colorRampPalette(palet)(nclass)
  }
  if (missing(shift)) {
    shift <- diff(st_bbox(x)[c(1, 3)]) / 700
  }
  x <- x[order(x$min), ]
  plot(st_geometry(x),
    col = NA,
    border = NA,
    add = add
  )
  for (i in seq_len(nrow(x))) {
    p <- st_geometry(x[i, ])
    plot(
      p + c(-shift, shift),
      col = light,
      border = light,
      add = TRUE
    )
    plot(
      p + c(shift * 5 / 3, -shift * 5 / 3),
      col = dark,
      border = dark,
      add = TRUE
    )
    plot(p,
      col = col[i],
      border = "NA",
      add = TRUE
    )
  }
  leg(
    type = "choro",
    pos = legend.pos,
    val = c(x$min, max(x$max)),
    val_rnd = 0,
    pal = col,
    title = legend.title,
    size = 0.8, title_cex = .8, val_cex = .6,
  )
}
