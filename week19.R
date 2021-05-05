library(dplyr)
library(purrr)
library(stringr)
library(ggplot2)

water <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-04/water.csv')

water

water %>%
  count(water_source, sort = TRUE)

water %>%
  filter(water_source != 'Borehole') + # Can remove this line for a huge bar
  group_by(water_source) %>%
  mutate(sources_ct = n()) %>%
  ggplot(aes(x = reorder(water_source, sources_ct), fill = facility_type)) +
  geom_bar(stat = 'count') +
  coord_flip()

# What about the other way?


water %>%
  group_by(facility_type) %>%
  mutate(facility_ct = n()) %>%
  ggplot(aes(x = reorder(facility_type, facility_ct), fill = water_source)) +
  geom_bar(stat = 'count')
