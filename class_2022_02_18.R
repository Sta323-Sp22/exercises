library(tidyverse)
library(rvest)

url = "http://rottentomatoes.com/"
polite::bow(url)

html = read_html(url)

get_movie_details = function(page_url) {
  
  page = read_html(page_url)
  
  list( 
    n_review = page %>% 
      html_elements(".scoreboard__link--tomatometer") %>%
      html_text() %>%
      str_remove(" Reviews") %>%
      as.numeric(),
    
    audiecnce_score = page %>%
      html_elements(".scoreboard") %>%
      html_attr("audiencescore") %>%
      as.numeric() %>%
      {./100}
  )
}

tibble::tibble(
  name = html %>% 
    html_elements(".ordered-layout__list--score:nth-child(1) .clamp-1") %>%
    html_text(),
  tomatometer = html %>%
    html_elements(".ordered-layout__list--score:nth-child(1) .dynamic-text-list__tomatometer-group span[slot=tomatometer-value]") %>%
    html_text2() %>%
    str_remove("%$") %>%
    as.numeric() %>%
    {./100},
  status = html %>%
    html_elements(".ordered-layout__list--score:nth-child(1) .dynamic-text-list__tomatometer-group span[slot=tomatometer-icon]") %>%
    html_attr("class") %>%
    str_remove_all("icon |icon--tiny |icon__") %>%
    str_replace_all("_", " ") %>%
    str_to_title(),
  
  url = html %>%
    html_elements(".ordered-layout__list--score:nth-child(1) .dynamic-text-list__tomatometer-group") %>%
    html_attr("href") %>%
    paste0(url, .)
) %>%
  mutate(
    detail = lapply(url, get_movie_details)
  ) %>%
  unnest_wider(detail)



