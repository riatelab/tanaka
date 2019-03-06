context("TEST ALL")


com <- st_read(system.file("gpkg/com.gpkg", package = "tanaka"), quiet = TRUE)
ras <- raster(system.file("grd/elev.grd", package = "tanaka"))

test_that("contour works", {
  expect_silent(tanaka_contour(x = ras))
  expect_silent(tanaka_contour(x = ras, nclass = 20))
  expect_silent(tanaka_contour(x = ras, breaks = seq(80,420,30)))
  expect_silent(tanaka_contour(x = ras, mask = as(com, "Spatial")))
})


test_that("tanaka works", {
  expect_silent(tanaka(x = ras))
  expect_silent(tanaka(x = ras, shift = 20))
  expect_silent(tanaka(x = ras, col = rev(c("#000004FF", "#231151FF",
                                            "#5F187FFF", "#982D80FF",
                                            "#D3436EFF","#F8765CFF",
                                            "#FEBA80FF", "#FCFDBFFF"))))
  expect_silent(tanaka(x = tanaka_contour(x = ras, breaks = seq(80,420,50),
                                          mask = com)))
})


fufun <- function(){
  for (i in list("bottomleft", "topleft", "topright", "bottomright",
                 "left", "right", "top", "bottom", "center",
                 "bottomleftextra", "n", c(589477, 6421370))){
    tanaka(x = ras, legend.pos =i, breaks = seq(80,420,125))
  }
}
test_that("legend works", {
  expect_silent(fufun())
})
