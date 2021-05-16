library(tidyverse)
library(zipcodeR)

broadband_raw <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-11/broadband.csv')


broadband <- broadband_raw %>%
  rename_with(
    ~ str_replace_all(., ' ', '_') %>%
      tolower) %>%
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
try <- broadband %>%
  filter(str_detect(county_name, 'County')) %>%
  mutate(county_short = str_replace(county_name, ' County', ''),
         # Can do something else here to raw broadband df
         )

# Configuring a placeholder error data frame in case mapping the
# search_county function ddoesn't find a match
error_df <- search_county('Los Angeles', 'CA')[1,] %>%
  mutate(zipcode = '0', zipcode_type = 'Error: search_county',
         major_city = 'Error: search_county',
         post_office_city = 'Error: search_county',
         county = 'Error: search_county', state = 'Error: search_county',
         lat = 0, lng = 0)


df_possib1 <- map2(try$county_short, try$st, 
     possibly(~ search_county(.x, .y), 
              error_df
              ) # otherwise
     )

df_possib1

df_bound <- df_possib1 %>%
  bind_rows(.id = 'id')


df_bound %>%
  select(county)


zips_joined <- df_bound %>%
  inner_join(try, by = c('county' = 'county_name'))

zips_joined

# The inner join gets rid of the original county_name column
# For some reason keeps county column-- sitll have county_short
zips_joined %>%
  select(st, county_id, avail, usage, county_short, 
         zipcode, lat, lng, population, major_city, zipcode_type,
         common_city_list, county)




# I don't think I actually need this huge data frame
# There's probably a better way to use the zip code information per county

# I just realized I joined only on county names-- probably puts
# counties together with the same name from different states-- whoops



str_sub(broadband$county_name)

str_detect(broadband$county_name, 'County')

str_replace(broadband$county_name, ' County', '')
