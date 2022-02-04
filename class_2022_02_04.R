library(tidyverse)

# Example 1

## Base R approach

draw_points = function(n) {
  list(
    x = runif(n, -1, 1),
    y = runif(n, -1, 1)
  )
}

in_unit_circle = function(l) {
  sqrt(l$x^2 + l$y^2) <= 1
}

n = 1e6
l = draw_points(n)
inside = in_unit_circle(l)

#plot(l$x, l$y, col = inside+1)

4*sum(inside) / n


## purrr / tibble approach

tibble(
  n = 10^(1:6)
) %>%
  mutate(
    draws = map(n, draw_points),
    circ = map(draws, in_unit_circle),
    frac = map_dbl(circ, mean),
    pi_est = 4 * frac,
    pi_err = pi - pi_est
  )

## Example 2 - discog

View(repurrrsive::discog)

## purrr map based approach

tibble(
  disc = repurrrsive::discog
) %>%
  mutate(
    id = map_int(disc, "id"),
    year = map_int(disc, c("basic_information","year")),
    artitst = map_chr(disc, list("basic_information", "artists", 1, "name"))
  )

## Tidyr version via hoist

tibble(disc = repurrrsive::discog) %>% 
  hoist(
    disc, 
    id = "id",
    year = c("basic_information", "year"), 
    title = c("basic_information", "title"),
    artist = list("basic_information", "artists", 1, "name"),
    label = list("basic_information", "labels", 1, "name")
  )


