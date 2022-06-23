#' @title Create a Contour Layer
#' @name tanaka_contour
#' @description Create a contour layer.
#' @param x a raster object.
#' @param nclass a number of class.
#' @param breaks a vector of break values.
#' @param mask a mask layer, a POLYGON or MULTIPOLYGON sf object.
#' @return A MULTIPOLYGON sf object is return. The data.frame contains 3 fields:
#' id, min (minimum value of the raster in the MULTIPOLYGON) and max (maximum
#' value of the raster in the MULTIPOLYGON).
#' @export
#' @importFrom sf st_sf st_sfc st_geometry st_collection_extract st_crs st_agr<-
#' st_cast st_intersection st_union st_as_sf st_geometry<-
#' st_make_valid
#' @importFrom mapiso mapiso
#' @examples
#' library(tanaka)
#' library(terra)
#' library(sf)
#' ras <- rast(system.file("tif/elev.tif", package = "tanaka"))
#' iso <- tanaka_contour(x = ras)
#' plot(st_geometry(iso), col = c(
#'   "#FBDEE1", "#F0BFC3", "#E7A1A6",
#'   "#DD8287", "#D05A60", "#C03239",
#'   "#721B20", "#1D0809"
#' ))
tanaka_contour <- function(x, nclass = 8, breaks, mask) {
  iso <- mapiso(x = x, nbreaks = nclass, breaks = breaks, mask = mask)
  names(iso)[1:3] <- c("id", "min", "max")
  return(iso)
}
