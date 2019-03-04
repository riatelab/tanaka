[![Travis build status](https://travis-ci.org/rCarto/tanaka.svg?branch=master)](https://travis-ci.org/rCarto/tanaka)



# Tanaka Method
![](https://raw.githubusercontent.com/rCarto/tanaka/master/img/tanaka.png)

Also called "relief contours method", "illuminated contour method" or "shaded contour lines method", this method enhances the representation of the relief on a map by using shaded contour lines. The result is a 3D-like map.

`tanaka` is a small package with two functions:

- `tanaka()` uses a `raster` object and displays the map directly;
- `tanaka_contour()` builds the isopleth polygon layer. 

Tanaka, K., 1950. The relief contour method of representing topography on maps. The Geographical Review.


## Installation
* Development version on GitHub
```{r}
require(remotes)
install_github("rCarto/tanaka")
```

## Demo
```{r}
library(tanaka)
library(elevatr)
library(raster)
# use elevatr to get elevation data
ras0 <- get_elev_raster(
  locations = data.frame(x = c(6.7, 7),
                         y = c(45.8,48)),
  z = 10,
  prj = "+init=epsg:4326"
)
ras <- crop(ras0, y = extent(c(6.7, 7, 45.8 ,46)))
# display the map
cols <- c("#F7E1C6", "#EED4C1", "#E5C9BE", "#DCBEBA", "#D3B3B6", "#CAA8B3", 
          "#C19CAF", "#B790AB", "#AC81A7", "#A073A1", "#95639D", "#885497", 
          "#7C4692", "#6B3D86", "#573775", "#433266", "#2F2C56", "#1B2847")
tanaka(ras, breaks = seq(500,4800,250), col = cols)
```
![](https://raw.githubusercontent.com/rCarto/tanaka/master/img/ex.png)

