# 
# 
# ```{r}
# library(haven)
# 
# ```
# 
# 
# ```{r}
# library(haven)
# issp.2016 <- read_sav(file.path(Sys.getenv('DATADIR_HIVA_LOCAL'), 'ISSP/issp_w2016_rog/ZA6900_v2-0-0.sav'))
# ```
# 
# ```{r}
# issp.2016
# ```
# 
# BE: In order to deliver one integrated harmonized data file for Belgium post stratification weights were calculated based upon age (three age
# groups: 18-39; 40-59; 60+), sex, and geographical classification (NUTS1 Flemish Region, Walloon Region, Brussels Capital Region). These
# characteristics are known for all sampled units and the population distributions are published by the Belgian Institute for National Statistics
# (Statbel). The age-sex distribution in each region is reproduced by the weights as well as the distribution over the regions. The result of this
# weighting procedure in combination with the sampling design is that the weights for respondents of the Brussels Capital Region are much
# smaller than the weights for the respondents of the Flemish and Walloon regions. The use of adequate software is always necessary when
# analyzing data with weights, but with these data it is vitally important when comparing the regions or analyzing only one region
# separately.



# https://stackoverflow.com/questions/46704878/circle-around-a-geographic-point-with-st-buffer
# 
# 
# ```{r}
# luchthaven <- st_point(x = c(4.4833857, 50.9010024), dim = "XY")
# luchthaven <- luchthaven %>% st_sfc(crs = 4326)
# ```
# 
# ```{r}
# library(mapview)
# mapview(luchthaven)
# ```
# 
# ```{r}
# mapview(st_buffer(luchthaven, 0.2))
# ```
# 
# 
# https://skyvector.com/airport/EBBR/Brussels-Airport
# Coordinates: N50°54.08' / E4°29.07'
# Elevation is 184.0 feet MSL. 
# 
# 
# ```{r}
# # https://stackoverflow.com/questions/46704878/circle-around-a-geographic-point-with-st-buffer
# 
# #dub <- st_point(x = c(dub_lon, dub_lat, dub_elv), dim = "XYZ")
# #dub <- dub %>% st_sfc(crs = 4326)
# ```
# 

# ```{r}
# qtm(world_tmap %>% filter(continent == 'Europe'))
# ```
# 
# ```{r}
# qtm(world_tmap %>% filter(continent == 'Europe', name != 'Russia'))
# ```

# 
# 
# 
# # http://bboxfinder.com/#50.388821,3.771057,50.455100,3.913536
# 
# ```{r}
# borinage_coords <- matrix(c(
#   3.771057,50.388821,
#   3.771057,50.455100,
#   3.913536,50.455100,
#   3.913536,50.388821,
#   3.771057,50.388821),ncol=2, byrow=TRUE)
# borinage_bb <- st_geometry(st_polygon(list(borinage.coords)))
# borinage_bb <- st_set_crs(borinage_bb, 4326)
# mapview(borinage_bb)
# ```
# 
# 
# ```{r}
# borinage_crop <- st_crop(munip, borinage_bb)
# mapview(borinage_crop)
# ```
# 
# 
# ```{r}
# mapview(st_join(munip, borinage_crop, join = st_contains, left=FALSE))
# ```
# 
# 
# ```{r}
# mapview(st_join(munip, munip.crop, join = st_touches, left=FALSE))
# ```
# 
# ```{r}
# mapview(st_join(munip, munip.crop, join = st_within, left=FALSE))
# ```
# 
# ```{r, warning=FALSE}
# munip.crop <- st_crop(munip, c(xmin=5.5, xmax=6, ymin=51, ymax=55))
# qtm(munip.crop, text = 'TX_MUNTY_DESCR_NL')
# ```
# 
# ```{r}
# mapview(munip.crop)
# ```
# 
# ```{r}
# mapview(munip[st_within(munip, munip.crop) %>% lengths > 0,])
# ```
# 
# 
# ```{r}
# st_within(munip, munip.crop)
# ```
# 
# 
# ```{r}
# munip %>%
#   filter(st_within(munip, munip.crop))
# ```
# 



# ---
#   title: "Tweak"
# output: 
#   html_document:
#   toc: TRUE
# toc_float: TRUE
# ---
#   
#   Tip: export as SVG and post-process in [Inkscape](https://inkscape.org/).
# 
# # Quick-save from mapview 
# 
# ```{r, eval=FALSE}
# data("BE_ADMIN_DISTRICT")
# district <- st_as_sf(BE_ADMIN_DISTRICT)
# districtmap <- mapview(district)
# mapshot(districtmap, 'mapview_districtmap.html')
# mapshot(districtmap, 'mapview_districtmap.png')
# ```
# 
# 
# # Save static maps with tmap
# 
# ```{r}
# 
# ```
# 
# 
# # Save static maps with ggplot
# 
# ```{r}
# 
# ```
# 
# 
# # Save interactive leaflet maps 
# 
# Standalone vs. dependencies
# 

# 
# 
# ---
#   title: "Tweak"
# output: 
#   html_document:
#   toc: TRUE
# toc_float: TRUE
# ---
#   
#   ```{r, message=FALSE, warning=FALSE}
# library(readr)
# library(BelgiumMaps.StatBel)
# library(sf)
# library(dplyr)
# library(tmap)
# ```
# 
# 
# 
# # Projection
# 
# 
# 

# 
# 
# ```{r}
# be.income <- be.income +
#   tm_layout(legend.show = FALSE)
# be.income.legend <- be.income +
#   tm_layout(legend.show = TRUE)
# save_tmap(be.income, 'output/be_income_muni_2016.png', width=1920, height=1080)
# save_tmap(be.income.legend, 'output/be_income_muni_2016_legend.png', width=1920, height=1080)
# save_tmap(be.income.legend, 'output/be_income_muni_2016_legend.svg', width=1920, height=1080)
# ```
# 
# 
# ```{r}
# # tmap_mode('view')
# # qtm(heritage_leuven, fill = 'start_year')
# # tmap_mode('plot')
# ```
# 
# 
# 

# 
# 
# # http://www.standaard.be/cnt/dmf20171025_03151950
# 
# 
# 
# 
# eu_nuts0 <- get_eurostat_geospatial(
#   resolution = "60", # detail 
#   nuts_level = "0") # NUTS 0-3
# 
# eu.mainland <- st_crop(eu_nuts0, c(xmin=-10, xmax=45, ymin=36, ymax=71))
# eu.mainland <- eu.mainland %>%
#   left_join(worktime.2017, by = c('CNTR_CODE' = 'geo'))
# 
# tm_shape(eu.mainland, projection="mercator") +
#   tm_fill(col = 'values', title = 'Percentage\ntemporary work',
#           legend.format=list(fun=function(x) paste0(formatC(x, digits=0, format="f"), " %"))) +
#   tm_borders(col = 'white', lwd = .5) + 
#   tm_layout(frame = FALSE)
# 
# # http://www.jla-data.net/2017/09/20/2017-09-19-tmap-legend/
# m.tempwork <- tm_shape(eu.mainland, projection="wintri") +
#   tm_fill(col = 'values', title = 'Percentage\ntemporary work', showNA = FALSE,
#           legend.format=list(fun=function(x) paste0(formatC(x, digits=0, format="f"), " %"))) +
#   tm_borders(col = 'white', lwd = .7) + 
#   tm_layout(frame = FALSE) +
#   tm_style_white(legend.format = list(text.separator= "-"))
# 
# save_tmap(m.tempwork, 'map_eu_tempwork.png', width = 1920, height = 1080)
# save_tmap(m.tempwork, 'map_eu_tempwork.svg', width = 1920, height = 1080)
# 
# internet <- get_eurostat('isoc_r_gov_i')
# internet.2018 <- internet %>%
#   filter(time == '2018-01-01', unit == 'PC_IND', indic_is == 'I_IUGOV12')
# 
# PC_IND pct individuals
# I_IUGOV12 	Internet use: interaction with public authorities (last 12 months) 
# 
# eu_nuts2 <- get_eurostat_geospatial(
#   resolution = "60", # detail 
#   nuts_level = "2") # NUTS 0-3
# 
# internet.2018 <- internet.2018 %>%
#   filter(geo %in% eu_nuts2$id)
# 
# eu_nuts2 <- eu_nuts2 %>%
#   left_join(internet.2018, by = c('id' = 'geo')) %>%
#   st_crop(c(xmin=-10, xmax=45, ymin=36, ymax=71))
# 
# tm_shape(eu_nuts2, projection="wintri") +
#   tm_fill(col = 'values', title = 'Percentage\ntemporary work',
#           legend.format=list(fun=function(x) paste0(formatC(x, digits=0, format="f"), " %"))) +
#   tm_borders(col = 'white', lwd = .7) + 
#   tm_layout(frame = FALSE) +
#   tm_style_white(legend.format = list(text.separator= "-"))

#st_crs(heritage) <- 31370

# ```{r}
# # Get a bounding box around Leuven
# # leuven_bb <- bb('Leuven', projection = '31370') # set projection to BE Lambert 72 https://epsg.io/31370
# # leuven_bb
# ```
# 
# ```{r}
# #quick thematic map with a bounding box around Leuven
# #qtm(heritage) # compare full map
# #qtm(heritage, bbox = 'Leuven')
# 
# #qtm(heritage, bbox = leuven_bb)
# ```
# 
# ```{r}
# # heritage_leuven <- crop_shape(heritage, leuven_bb)
# # heritage_leuven
# ```
# 
# 
# ```{r}
# mapview(heritage)
# ```
