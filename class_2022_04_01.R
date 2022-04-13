library(tidyverse)
library(lubridate)

system.time({
  nyc = readr::read_csv("/data/Parking_Violations_Issued_-_Fiscal_Year_2022.csv")
})

nyc = nyc %>% 
  janitor::clean_names() %>%
  select(registration_state:issuing_agency, 
         violation_location, violation_precinct, violation_time,
         house_number:intersecting_street, vehicle_color) %>%
  mutate(issue_date = mdy(issue_date)) %>% 
  mutate(issue_day = day(issue_date),
         issue_month = month(issue_date),
         issue_year = year(issue_date),
         issue_wday = wday(issue_date, label=TRUE)) %>%
  filter(issue_year %in% 2021:2022)

nyc %>%
  filter(violation_precinct < 32, violation_precinct != 0) %>%
  group_by(violation_precinct) %>%
  count(issue_wday) %>%
  ggplot(aes(x=issue_wday, y=n)) +
    geom_point() +
    facet_wrap(~violation_precinct)
