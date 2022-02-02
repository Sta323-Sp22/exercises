library(nycflights13)
library(dplyr)

# 1. How many flights to Los Angeles (LAX) did each of the legacy carriers 
#    (AA, UA, DL or US) have in May from JFK, and what was their average duration?
  
flights %>%
  filter(dest == "LAX") %>%
  #filter(carrier == "UA" | carrier == "AA" | ...)
  filter(carrier %in% c("AA","UA","DL","US")) %>%
  filter(month == 5) %>%
  filter(origin == "JFK") %>%
  group_by(carrier) %>%
  summarize(
    n = n(),
    avg_dur = mean(air_time, na.rm=TRUE)
  )


# 2. What was the shortest flight out of each airport in 
#    terms of distance? In terms of duration?

flights %>%
  select(origin, dest, distance) %>%
  group_by(origin) %>%
  arrange(distance) %>%
  filter(distance == distance[1]) %>%
  distinct()

flights %>%
  select(origin, dest, distance) %>%
  group_by(origin) %>%
  arrange(distance) %>%
  distinct() %>%
  top_n(n=-2, wt=distance)
  

flights %>%
  select(origin, dest, air_time) %>%
  group_by(origin) %>%
  arrange(air_time) %>%
  distinct() %>%
  top_n(n=-3) %>%
  arrange(origin, air_time)



# 3. Which plane (check the tail number) flew out of each 
#    New York airport the most?

flights %>%
  count(origin, tailnum) %>%
  group_by(origin) %>%
  top_n(1) # all NA need to filter

flights %>%
  filter(!is.na(tailnum)) %>%
  count(origin, tailnum) %>%
  group_by(origin) %>%
  top_n(1) # all NA need to filter

# 4. Which date should you fly on if you want to have the 
#    lowest possible average departure delay? What about 
#    arrival delay?

flights %>%
  mutate(date = paste(year, month, day, sep="/")) %>%
  group_by(date) %>%
  summarize(avg_dep_delay = mean(dep_delay, na.rm=TRUE), .groups = "drop") %>%
  top_n(-1)

flights %>%
  mutate(date = paste(year, month, day, sep="/")) %>%
  group_by(date) %>%
  summarize(avg_arr_delay = mean(arr_delay, na.rm=TRUE), .groups = "drop") %>%
  top_n(-1)
