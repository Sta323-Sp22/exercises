library(tidyverse)

## Example 1

(grades = tibble::tribble(
  ~name, ~hw_1, ~hw_2, ~hw_3, ~hw_4, ~proj_1, ~proj_2,
  "Alice",    19,    19,    18,    20,      89,      95,
  "Bob",      18,    20,    18,    16,      77,      88,
  "Carol",    18,    20,    18,    17,      96,      99,
  "Dave",     19,    19,    18,    19,      86,      82
))

grades %>%
  mutate(
    final_grade = 0.5*(hw_1 + hw_2 + hw_3 + hw_4)/80 + 0.5*(proj_1 + proj_2)/200
  )

grades %>%
  pivot_longer(
    cols = -name, 
    names_to = "assign", 
    values_to="grade"
  ) %>%
  separate(col = assign, sep="_", into=c("type", "id")) %>%
  group_by(name, type) %>%
  summarize(total = mean(grade)) %>%
  pivot_wider(
    id_cols = name, 
    names_from=type, 
    values_from = total
  ) %>%
  mutate(
    overall = 0.5 * hw/20 + 0.5 * proj / 100
  )

## Exercise 1

# Create contingency table with islands (rows) and species (cols)

palmerpenguins::penguins %>%
  count(island, species) %>%
  pivot_wider(
    id_cols = island, 
    names_from = species, 
    values_from = n, 
    values_fill = 0
  )


## Example 2

ships = tibble(ships = repurrrsive::sw_starships) %>%
    unnest_wider(ships) %>%
    select(ship = name, url)


sw_df %>%
  unnest_wider(people) %>% 
  select(name, starships) %>%
  unnest_longer(starships) %>%
  inner_join(ships, by = c("starships" = "url")) %>%
  select(-starships) %>%
  group_by(name) %>%
  summarize(ships = list(ship), .groups = "drop")


## Exercise 2


### Q1 Which planet appeared in the most starwars film (according to the data in sw_planet)?

repurrrsive::sw_planets %>%
  tibble::tibble(planet = .) %>%
  unnest_wider(planet) %>%
  select(name, films) %>%
  unnest_longer(films) %>%
  count(name) %>%
  arrange(desc(n)) %>%
  top_n(5)

### Q2 - Which planet was the homeworld of the most characters in the starwars films?

sw_df %>%
  unnest_wider(people) %>%
  select(name, url = homeworld) %>%
  left_join(
    repurrrsive::sw_planets %>%
      tibble::tibble(planet = .) %>%
      unnest_wider(planet) %>%
      select(name, url),
    by = "url"
  ) %>%
  select(
    char_name = name.x, homeworld = name.y
  ) %>%
  count(homeworld) %>%
  arrange(desc(n))


