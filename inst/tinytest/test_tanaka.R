#init
com <- sf::st_read(system.file("gpkg/com.gpkg", package = "tanaka"),
                   quiet = TRUE)
ras <- terra::rast(system.file("tif/elev.tif", package = "tanaka"))

expect_silent(tanaka_contour(x = ras))
expect_silent(tanaka_contour(x = ras, nclass = 20))
expect_silent(tanaka_contour(x = ras, breaks = seq(80, 420, 30)))
expect_silent(tanaka_contour(x = ras, mask = com))
expect_silent(tanaka(x = ras))
expect_silent(tanaka(x = ras, shift = 20))
expect_silent(tanaka(x = ras, col = rev(
  c(
    "#000004FF",
    "#231151FF",
    "#5F187FFF",
    "#982D80FF",
    "#D3436EFF",
    "#F8765CFF",
    "#FEBA80FF",
    "#FCFDBFFF"
  )
)))
expect_silent(tanaka(x = tanaka_contour(
  x = ras,
  breaks = seq(80, 420, 50),
  mask = com
)))

