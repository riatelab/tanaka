## this function is a light version of legendChoro from cartography...
#' @name legendtanaka
#' @title legendtanaka
#' @importFrom graphics par rect strheight strwidth xinch
#' @noRd
legendtanaka <- function(pos = "topleft",
                         title.txt = "Title of the legend",
                         title.cex = 0.8,
                         values.cex = 0.6,
                         breaks,
                         col,
                         cex = 1,
                         values.rnd = 2,
                         border = "black"){
  # exit for none
  positions <- c("bottomleft", "topleft", "topright", "bottomright",
                 "left", "right", "top", "bottom", "center",
                 "bottomleftextra")
  if(length(pos) == 1){if(!pos %in% positions){return(invisible())}}

  # figdim in geo coordinates
  x1 <- par()$usr[1]
  x2 <- par()$usr[2]
  y1 <- par()$usr[3]
  y2 <- par()$usr[4]

  # offsets
  delta1 <- xinch(0.15) * cex
  delta2 <- delta1 / 2

  # variables internes
  width <- (x2 - x1) / (30/cex)
  height <- width / 1.5

  # extent
  if(!is.character(breaks)){
    breaks <- as.numeric(round(breaks, values.rnd))
  }

  nodata.txt <- NULL
  longval <- max(strwidth(c(breaks, nodata.txt), cex = values.cex))
  legend_xsize <- max(width + longval,
                      strwidth(title.txt, cex = title.cex) - delta2) - delta2
  legend_ysize <- (length(breaks)-1) * height +  strheight(title.txt, cex = title.cex)

  # Get legend position
  legcoord <- legpos(pos = pos, x1 = x1, x2 = x2, y1 = y1, y2 = y2,
                     delta1 = delta1, delta2 = delta2,
                     legend_xsize = legend_xsize,
                     legend_ysize = legend_ysize)
  xref <- legcoord$xref
  yref <- legcoord$yref

  # box display
  for (i in 0:(length(breaks)-2)){
    rect(xref, yref + i * height, xref + width, yref + height + i * height,
         col = col[i+1], border = border, lwd = 0.4)
  }


  # text display
  for (i in 1:(length(breaks))){
    text(x = xref + width + delta2, y = yref + (i-1) * height,
         labels = breaks[i], adj = c(0,0.5), cex = values.cex)
  }

  # title
  text(x = xref, y = yref + (length(breaks)-1) * height + delta1,
       labels = title.txt, adj = c(0,0), cex = title.cex)
}



legpos <- function(pos, x1, x2, y1, y2, delta1, delta2,
                   legend_xsize, legend_ysize){
  # Position
  if(length(pos) == 2){
    return(list(xref = pos[1], yref = pos[2]))
  }
  if (pos == "bottomleft") {
    xref <- x1 + delta1
    yref <- y1 + delta1
  }
  if (pos == "bottomleftextra") {
    xref <- x1 + delta1
    yref <- y1 + delta1 + graphics::strheight(s = "hp\nhp", cex = 0.6, font = 3)
  }
  if (pos == "topleft") {
    xref <- x1 + delta1
    yref <- y2 - 2 * delta1 - legend_ysize
  }
  if (pos == "topright") {
    xref <- x2 - 2 * delta1 - legend_xsize
    yref <- y2 -2 * delta1 - legend_ysize
  }
  if (pos == "bottomright") {
    xref <- x2 - 2 * delta1 - legend_xsize
    yref <- y1 + delta1
  }
  if (pos == "left") {
    xref <- x1 + delta1
    yref <- (y1+y2)/2-legend_ysize/2 - delta2
  }
  if (pos == "right") {
    xref <- x2 - 2*delta1 - legend_xsize
    yref <- (y1+y2)/2-legend_ysize/2 - delta2
  }
  if (pos == "top") {
    xref <- (x1+x2)/2 - legend_xsize/2
    yref <- y2 - 2*delta1 - legend_ysize
  }
  if (pos == "bottom") {
    xref <- (x1+x2)/2 - legend_xsize/2
    yref <- y1 + delta1
  }
  if (pos == "center") {
    xref <- (x1+x2)/2 - legend_xsize/2
    yref <- (y1+y2)/2-legend_ysize/2 - delta2
  }
  return(list(xref = xref, yref = yref))
}



