#' @title Contour Layer
#' @name rasToPoly
#' @description Create a contour layer.
#' @param x a raster or an sf contour layer.
#' @param nclass number of class.
#' @param breaks list of breaks.
#' @param mask a mask layer, sf object.
#' @export
#' @import sf
#' @import isoband
#' @import raster
rasToPoly <- function(x, nclass = 8, breaks, mask){
  ext <- x@extent
  nc <- x@ncols
  nr <- x@nrows
  val <- values(x)
  lon <- seq(ext[1], ext[2], length.out = nc)
  lat <- seq(ext[3], ext[4], length.out = nr)
  m <- matrix(data = val, nrow = nc, dimnames = list(lon,lat))
  vmin <- min(m, na.rm = TRUE)
  vmax <- max(m, na.rm = TRUE)
  if(missing(breaks)){
    breaks <- seq(from = vmin, to = vmax, length.out = (nclass+1))
  }else{
    breaks <- sort(unique(c(vmin, breaks[breaks > vmin & breaks < vmax], vmax)))
  }
  lev_low = breaks[1:(length(breaks)-1)]
  lev_high = breaks[2:length(breaks)]
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
  if(!missing(mask)){
    if(methods::is(mask, "Spatial")){mask <- st_as_sf(mask)}
    options(warn=-1)
    res <- st_cast(st_intersection(x = res, y = st_buffer(st_union(mask),0)))
    options(warn=0)
  }
  return(res)
}
