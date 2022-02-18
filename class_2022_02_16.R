library(tidyverse)
library(stringr)


## Exercise 1

names = c("Jeremy Cruz", "Nathaniel Le", "Jasmine Chu", "Bradley Calderon Raygoza", 
          "Quinten Weller", "Katelien Kanamu-Hauanio", "Zuhriyaa al-Amen", 
          "Travale York", "Alexis Ahmed", "David Alcocer", "Jairo Martinez", 
          "Dwone Gallegos", "Amanda Sherwood", "Hadiyya el-Eid", "Shaimaaa al-Can", 
          "Sarah Love", "Shelby Villano", "Sundus al-Hashmi", "Dyani Loving", 
          "Shanelle Douglas", "Colin Rundel")

### detect if the person's first name starts with a vowel (a,e,i,o,u)

str_subset(names, "^[AEIOU]")

### detect if the person's last name starts with a vowel

str_subset(names, " [AEIOUaeiou]")

str_subset(names, regex(" [AEIOU]", ignore_case = TRUE))

str_subset(names, "R[a-z]+$")

### detect if either the person's first or last name start with a vowel

str_subset(names, "^[AEIOU]| [AEIOUaeiou]")

### detect if neither the person's first nor last name start with a vowel

names[ 
  (!str_detect(names, "^[AEIOU]")) |
   (!str_detect(names, "[AEIOUaeiou]"))
]


## Exercise 2



