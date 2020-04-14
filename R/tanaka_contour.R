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
#' st_cast st_intersection st_union st_as_sf st_geometry<- st_set_crs
#' st_make_valid
#' @importFrom isoband isobands iso_to_sfg
#' @importFrom raster extent ncol nrow xres yres values
#' @examples
#' library(tanaka)
#' library(raster)
#' library(sf)
#' ras <- raster(system.file("grd/elev.grd", package = "tanaka"))
#' iso <- tanaka_contour(x = ras)
#' plot(st_geometry(iso), col = c("#FBDEE1", "#F0BFC3", "#E7A1A6",
#'                                "#DD8287", "#D05A60", "#C03239",
#'                                "#721B20", "#1D0809"))
tanaka_contour <- function(x, nclass = 8, breaks, mask) {
  ext <- extent(x)
  nc <- ncol(x)
  nr <- nrow(x)
  xr <- xres(x) / 2
  yr <- yres(x) / 2

  lon <- seq(ext[1] + xr, ext[2] - xr, length.out = nc)
  lat <- seq(ext[4] - yr, ext[3] + yr, length.out = nr)
  m <- matrix(data = values(x),
              nrow = nr,
              byrow = TRUE)

  # breaks management
  vmin <- min(m, na.rm = TRUE)
  vmax <- max(m, na.rm = TRUE)
  if (missing(breaks)) {
    breaks <- seq(from = vmin,
                  to = vmax,
                  length.out = (nclass + 1))
  } else{
    breaks <-
      sort(unique(c(vmin, breaks[breaks > vmin & breaks < vmax], vmax)))
  }
  lev_low  <- breaks[1:(length(breaks) - 1)]
  lev_high <- breaks[2:length(breaks)]

  # raster to sf
  raw <- isobands(
    x = lon,
    y = lat,
    z = m,
    levels_low = lev_low,
    levels_high = c(lev_high[-length(lev_high)], vmax + 1e-10)
  )

  bands <- iso_to_sfg(raw)

  iso <- st_sf(
    id = seq_along(bands),
    min = lev_low,
    max = lev_high,
    geometry = st_sfc(bands),
    crs = st_crs(x)
  )

  # clean geoms
  st_geometry(iso) <- st_make_valid(st_geometry(iso))

  if (methods::is(st_geometry(iso), "sfc_GEOMETRY")) {
    st_geometry(iso) <-
      st_collection_extract(st_geometry(iso), "POLYGON")
  }

  # mask management
  if (!missing(mask)) {
    st_agr(iso) <- "constant"
    if(st_crs(iso)$proj4string == st_crs(mask)$proj4string){
      iso <- st_set_crs(iso, NA)
      iso <- st_set_crs(iso, st_crs(mask))
      iso <- st_cast(st_intersection(x = iso, y = st_union(st_geometry(mask))))
    }
  }
  return(iso)
}
