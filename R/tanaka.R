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
