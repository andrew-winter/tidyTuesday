library(tidyverse)
library(usmap)

post_offices <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-04-13/post_offices.csv')

post_offices

# What is the oldest still-operating post office in each state?
post_offices %>%
  select(name, state, county1, established, discontinued, duration) %>%
  filter(is.na(discontinued)) %>%
  group_by(state) %>%
  slice_min(established) %>%
  arrange(established)

# What is the longest-operating post office in each state, open or not?
post_offices %>%
  select(name, state, county1, established, discontinued, duration) %>%
  group_by(state) %>%
  slice_max(duration) %>%
  arrange(desc(duration))


# There's some data quality issues-- I don't think the Buffalo post office
## in KS was opened in 186, and we can't say the Smilax post office in AL
## was discontinued in 19223, because it hasn't happened yet

# Before trying to "fix" these answers to my questions,
## I'm going to look at these probably-wrong years
## Let's ignore location for now

po <- post_offices %>%
  select(name, state, county1, established, discontinued, duration)

po %>%
  filter(established < 1700 | discontinued > 2021) %>%
  print(n = Inf)



# Alright, not so bad-- let's fix the original data frame
# Have to explicitly allow for NAs, bc they would be excluded otherwise
post_offices <- post_offices %>%
  filter(
    (established >= 1639 & discontinued <= 2021) |
      is.na(established) | is.na(discontinued)
    )

# And reassign our location-less data frame
po <- post_offices %>%
  select(name, state, county1, established, discontinued, duration)


# Oldest post office per state?
po %>%
  group_by(state) %>%
  slice_min(established) %>%
  arrange(established) %>%
  print(n = Inf)

# This is still giving me triple digit established years!
