# Tanaka Method

[![Travis build status](https://travis-ci.org/rCarto/tanaka.svg?branch=master)](https://travis-ci.org/rCarto/tanaka)
[![Coverage status](https://codecov.io/gh/rCarto/tanaka/branch/master/graph/badge.svg)](https://codecov.io/github/rCarto/tanaka?branch=master)

![](https://raw.githubusercontent.com/rCarto/tanaka/master/img/banner.png)  

Also called "relief contours method", "illuminated contour method" or "shaded 
contour lines method", the Tanaka method<sup>[1](#fn1)</sup> enhances the representation of topography 
on a map by using shaded contour lines. The result is a 3D-like map.

This package is a simplified implementation of the Tanaka method, north-west white contours represent 
illuminated topography and south-east black contours represent shaded topography. 
Even if the results are quite satisfactory, a more refined method could be used 
based on the Kennelly and Kimerling's paper<sup>[2](#fn2)</sup>. 


`tanaka` is a small package with two functions:

- `tanaka()` uses a `raster` object and displays the map directly;
- `tanaka_contour()` builds the isopleth polygon layer. 


The contour lines creation relies on [`isoband`](https://github.com/clauswilke/isoband), 
spatial manipulation and display relie on [`sf`](https://github.com/r-spatial/sf). 


## Installation
* Development version on GitHub
```{r}
require(remotes)
install_github("rCarto/tanaka")
```

## Demo

This example is based on the dataset shipped within the package. 
```{r}
library(tanaka)
library(raster)
ras <- raster(system.file("grd/elev.grd", package = "tanaka"))
tanaka(ras, breaks = seq(80,400,20), 
       legend.pos = "topright", legend.title = "Elevation\n(meters)")
```
![](https://raw.githubusercontent.com/rCarto/tanaka/master/img/ex1.png)  

This example is based on an  elevation raster downloaded via 
[`elevatr`](https://github.com/jhollist/elevatr). 
```{r}
library(tanaka)
library(elevatr)
# use elevatr to get elevation data
ras <- get_elev_raster(locations = data.frame(x = c(6.7, 7), y = c(45.8,46)),
                       z = 10, prj = "+init=epsg:4326", clip = "locations")
# custom color palette
cols <- c("#F7E1C6", "#EED4C1", "#E5C9BE", "#DCBEBA", "#D3B3B6", "#CAA8B3", 
          "#C19CAF", "#B790AB", "#AC81A7", "#A073A1", "#95639D", "#885497", 
          "#7C4692", "#6B3D86", "#573775", "#433266", "#2F2C56", "#1B2847")
# display the map
tanaka(ras, breaks = seq(500,4800,250), col = cols)
```
![](https://raw.githubusercontent.com/rCarto/tanaka/master/img/ex2.png)  


<a name="fn1">1</a>: Tanaka, K. (1950). The relief contour method of representing topography on maps. *Geographical Review, 40*(3), 444-456.  
<a name="fn2">2</a>: Kennelly, P., & Kimerling, A. J. (2001). Modifications of Tanaka's illuminated contour method. *Cartography and Geographic Information Science, 28*(2), 111-123.


