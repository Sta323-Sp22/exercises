library(rvest)
library(tidyverse)

## file system functions

dir()
dir("../")
dir("../", recursive = TRUE)
dir("../", full.names=TRUE)

basename(
  dir("../exercises", full.names=TRUE)
)

dirname(
  dir("../exercises", full.names=TRUE)
)

file.path("..", "exercises")
file.path("../", "exercises")

dir.create("data/lq")
dir.create("data/lq", recursive = TRUE)
dir.create("data/lq", recursive = TRUE, showWarnings = FALSE)

file.exists("data/lq")
dir.exists("class_2022_01_12.R")
dir.exists("data/lq")

fs::dir_ls()


basename(
  dir(full.names = TRUE)
)


here::here()

## LQ Stuff

state.name
state.abb

url = "http://wyndhamhotels.com/laquinta/birmingham-alabama/la-quinta-birmingham-hoover/overview"
cat("Getting", "la-quinta-birmingham-hoover.html", "\n")
download.file(
  url = url,
  destfile = file.path("data/lq/", "la-quinta-birmingham-hoover.html"),
  quiet = TRUE
)



## Dennys JSON api

r = 1000
limit = 50
url = glue::glue(paste0(
  "https://nomnom-prod-api.dennys.com/restaurants/near?",
  "lat=35.7804&long=-78.6391&radius={r}&limit={limit}",
  "&nomnom=calendars&nomnom_calendars_from=20220222",
  "&nomnom_calendars_to=20220302&nomnom_exclude_extref=999"
))

d = jsonlite::read_json(url)
View(d)
