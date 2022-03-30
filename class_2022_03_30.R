library(tidyverse)
library(sf)

nc = read_sf("data/gis/nc_counties/", quiet=TRUE)
air = read_sf("data/gis/airports/", quiet=TRUE)
hwy = read_sf("data/gis/us_interstates/", quiet=TRUE)

nc %>% 
  select(-AREA:FIPS) %>%
  mutate(
    intersect = st_intersects(nc, air),
    n_air = map_int(intersect, length)    
  ) %>%
  filter(n_air > 0)
