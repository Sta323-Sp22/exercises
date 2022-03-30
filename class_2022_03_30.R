library(tidyverse)
library(sf)

nc = read_sf("data/gis/nc_counties/", quiet=TRUE)
air = read_sf("data/gis/airports/", quiet=TRUE)
hwy = read_sf("data/gis/us_interstates/", quiet=TRUE)

