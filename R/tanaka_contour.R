#' @title Create a Contour Layer
#' @name tanaka_contour
#' @description Create a contour layer.
#' @param x a raster object.
#' @param nclass a number of class.
#' @param breaks a list of breaks.
#' @param mask a mask layer, a POLYGON or MULTIPOLYGON sf object.
#' @return A MULTIPOLYGON sf object is return. The data.frame contains 3 fields:
#' id, min (minimum value of the raster in the MULTIPOLYGON) and max (maximum
#' value of the raster in the MULTIPOLYGON).
#' @export
#' @import sf
#' @import isoband
#' @import raster
#' @import lwgeom
#' @examples
#' library(tanaka)
#' library(raster)
#' library(sf)
#' ras <- raster(system.file("grd/elev.grd", package = "tanaka"))
#' iso <- tanaka_contour(x = ras)
#' plot(st_geometry(iso), col = c("#FBDEE1", "#F0BFC3", "#E7A1A6",
#'                                "#DD8287", "#D05A60", "#C03239",
#'                                "#721B20", "#1D0809"))
tanaka_contour <- function(x, nclass = 8, breaks, mask){
  # data preparation
  ext <- x@extent
  nc <- x@ncols
  nr <- x@nrows
  val <- values(x)
  lon <- seq(ext[1], ext[2], length.out = nc)
  lat <- seq(ext[3], ext[4], length.out = nr)
  m <- matrix(data = val, nrow = nc, dimnames = list(lon,lat))

  # breaks management
  vmin <- min(m, na.rm = TRUE)
  vmax <- max(m, na.rm = TRUE)
  if(missing(breaks)){
    breaks <- seq(from = vmin, to = vmax, length.out = (nclass+1))
  }else{
    breaks <- sort(unique(c(vmin, breaks[breaks > vmin & breaks < vmax], vmax)))
  }
  lev_low = breaks[1:(length(breaks)-1)]
  lev_high = breaks[2:length(breaks)]

  # raster to sf
  raw <- isobands(x = as.numeric(rownames(m)),
                  y = rev(as.numeric(colnames(m))),
                  z = t(m),
                  levels_low = lev_low,
                  levels_high = c(lev_high[-length(lev_high)], vmax + 1e-10))
  bands <- iso_to_sfg(raw)
  res <- st_sf(id = 1:length(bands),
               min = lev_low,
               max = lev_high,
               geometry = st_sfc(bands),
               crs = st_crs(x))
  # clean geoms
  st_geometry(res) <- st_make_valid(st_geometry(res))
  if(methods::is(st_geometry(res),"sfc_GEOMETRY")){
    st_geometry(res) <-   st_collection_extract(st_geometry(res), "POLYGON")
  }

  # mask management
  if(!missing(mask)){
    if(methods::is(mask, "Spatial")){mask <- st_as_sf(mask)}
    st_agr(res) <- "constant"
    res <- st_cast(st_intersection(x = res, y = st_union(mask)))
  }
  return(res)
}

