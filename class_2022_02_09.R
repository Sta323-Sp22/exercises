library(tidyverse)
library(palmerpenguins)

## Exercise 1

penguins %>%
  filter(!is.na(sex)) %>%
  ggplot(
    aes(
      x = body_mass_g,
      fill = species
    )
  ) + 
  geom_density(alpha=0.5, color=NA) + 
  facet_wrap(~ sex, ncol=1) + 
  labs(
    color = "Species",
    x = "Body Mass (g)",
    y = ""
  )


## Exercise 2

penguins %>%
  ggplot(
    aes(
      x = flipper_length_mm,
      y = bill_length_mm,
      color = species,
      shape = species
    )
  ) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("darkorange", "purple", "cyan4"))


