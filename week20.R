library(tidyverse)
library(zipcodeR)

broadband_raw <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-11/broadband.csv')


broadband <- broadband_raw %>%
  rename_with(~ str_replace_all(., ' ', '_') %>% tolower) %>%
  rename(avail = broadband_availability_per_fcc, usage = broadband_usage)

broadband

# avail is % of people per county with access to
 # fixed terrestrial broadband at 25 down/3 up mbps in 2017
# usage is % of people per county who use broadband internet
# https://www.fcc.gov/document/broadband-deployment-report-digital-divide-narrowing-substantially-0

search_county('Los Angeles', 'CA')$zipcode

# I want to programatically look at counties per each row
# and make a data frame out of all zip codes in a certain county

# I'll filter out county, and then remove the word
broadband %>%
  filter(str_detect(county_name, 'County')) %>%
  mutate(county_name = county_name) # do something
