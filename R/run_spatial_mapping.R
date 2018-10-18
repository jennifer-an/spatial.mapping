
#' @title run_spatial_mapping
#' @name run_spatial_mapping
#' @author Jennifer An
#' @description maps two spatial polygons by
#' calculating the proportion of area overlapping
#' @param sp1 SpatialPolygonsDataFrame
#' @param sp2 SpatialPolygonsDataFrame
#' @oaram sp1_name Name of field in sp1 for mapping
#' @param sp2_name Name of field in sp2 for mapping
#' @import data.table dplyr rgdal raster rgeos
#' @example
#' require(rgdal)
#' sp1 <- readOGR(".../POA_2016_AUST")
#' sp2 <- readOGR(".../SA2_2016_AUST")
#' sp1_name <- "POA_CODE16"
#' sp2_name <- "SA2_MAIN16"
#' run_spatial_mapping(sp1=sp1, sp2=sp2, sp1_name=sp1_name, sp2_name=sp2_name)
#' @export
run_spatial_mapping <- function(sp1, sp2, sp1_name, sp2_name) {
  message("calculating...\r", appendLF=FALSE)
  flush.console()
  projection(sp1) <- projection(sp2)
  a <- intersect(sp1, sp2)
  a$area <- area(a)
  r <- as.data.table(a)
  r <- r[, sum(area), by=c(sp1_name, sp2_name)] %>%
    setnames(old="V1", new="intersect_area")

  sp2$area <- area(sp2)
  sp1$area <- area(sp1)

  r_sp2 <- data.table(sp2 = sp2[[sp2_name]], sp2_area = sp2[["area"]]) %>%
    setnames(old="sp2", new=sp2_name)
  r_sp1 <- data.table(sp1 = sp1[[sp1_name]], sp1_area = sp1[["area"]]) %>%
    setnames(old="sp1", new=sp1_name)
  r <- merge(r, r_sp2, all.x=T, by=c(sp2_name))
  r <- merge(r, r_sp1, all.x=T, by=c(sp1_name))

  r[, sp2_count := .N, by=c(sp2_name)]
  r[, sp1_count := .N, by=c(sp1_name)]

  r[, sp1_prop := round(intersect_area/sp2_area, 2)]
  r[, sp2_prop := round(intersect_area/sp1_area, 2)]

  setnames(r,
           old=c("sp1_area", "sp2_area",
                 "sp1_count", "sp2_count",
                 "sp1_prop", "sp2_prop"),
           new=c(paste0(sp1_name, "_area"), paste0(sp2_name, "_area"),
                 paste0(sp1_name, "_count"), paste0(sp2_name, "_count"),
                 paste0(sp1_name, "_prop"), paste0(sp2_name, "_prop")))

  message("complete!       \r", appendLF=FALSE)

  return(r)
}

