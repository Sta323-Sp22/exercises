library(tidyverse)

## Demo 1 - 

houses = jsonlite::read_json(
  "https://www.anapioficeandfire.com/api/houses?pageSize=50"
) %>%
  tibble(house = .) %>%
  tidyr::unnest_wider(house)
View(houses)

jsonlite::read_json(
  "https://www.anapioficeandfire.com/api/houses?pageSize=50&page=2"
) %>%
  tibble(house = .) %>%
  tidyr::unnest_wider(house) %>%
  View()

### Pagination 

res = list()
page = 1
pageSize = 50

repeat {
  cat("Downloading page", page, "\n")
  d = jsonlite::read_json( glue::glue(
    "https://www.anapioficeandfire.com/api/houses?pageSize={pageSize}&page={page}"
  ) )
  
  res = c(res, d)
  
  if (length(d) != pageSize)
    break
  
  page = page + 1
}

length(res)

res %>%
  tibble(house = .) %>%
  tidyr::unnest_wider(house) %>%
  View()


## Demo 2 - httr2

library(httr2)

resp = request("https://www.anapioficeandfire.com/api/houses") %>%
  req_url_query(
    pageSize = 50,
    page = 9
  ) %>%
  #req_dry_run()
  req_perform()

resp

resp %>%
  resp_status()

resp %>%
  resp_body_json() %>%
  tibble(house = .) %>%
  tidyr::unnest_wider(house) %>%
  View()

resp %>% 
  resp_headers()

links = resp %>% 
  resp_header("link")

get_links = function(resp) {
  resp %>% 
    resp_header("link") %>%
    str_match_all("<(.*?)>; rel=\"(.*?)\"") %>%
    .[[1]] %>%
    {setNames(as.list(.[,2]), .[,3])}
}

resp = request("https://www.anapioficeandfire.com/api/houses") %>%
  req_url_query(
    pageSize = 50,
    page = 1
  ) %>%
  req_perform()

res = resp %>% resp_body_json()
links = get_links(resp)

page = 2
repeat {
  if (is.null(links[["next"]]))
    break
  
  cat("Getting page", page, "\n")
  resp = request(links[["next"]]) %>%
    req_perform()
  
  res = c(res, resp %>% resp_body_json())
  links = get_links(resp)
  
  page = page+1
}



## Exercise 1

res = list()
page = 1
pageSize = 50

repeat {
  cat("Downloading page", page, "\n")
  d = jsonlite::read_json( glue::glue(
    "https://www.anapioficeandfire.com/api/characters?pageSize={pageSize}&page={page}"
  ) )
  
  res = c(res, d)
  
  if (length(d) != pageSize)
    break
  
  page = page + 1
}

length(res)

char = res %>%
  tibble(char = .) %>%
  tidyr::unnest_wider(char)
  
char %>%
  summarize(n = n())


char %>%
  summarize(prop_dead = sum(died != "") / n() )



## Demo 3
# https://github.com/settings/tokens
# https://docs.github.com/en/rest/reference/gists
