library(dplyr)
library(purrr)
library(stringr)
olympics <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-07-27/olympics.csv')

olympics %>%
  count(medal, sort = TRUE)

# Narrow some of the data to medal winners and Summer olympics
sdf <- filter(olympics, !is.na(medal) & season == 'Summer')

# Early exploration====
sdf %>%
  count(team, medal, sort = TRUE)

# Curious if there are discrepancies between city/year combos and games label
df1 <- count(sdf, city, year, sort = TRUE)
df2 <- count(sdf, games, sort = TRUE)
inner_join(df1, df2, by = 'n') %>%
  print(n = 30)
# Not clear

anti_join(df1, df2, by = 'n')
# Clear-- 1956 Olympics split between Melbourne and Stockholm for some reason

filter(df1, year == 1956)
sdf %>%
  filter(year == 1956) %>%
  group_split(city)
# Saw it on Wikipedia too, but equestrian events in 1956 took place in Stockholm

#====

# Should start asking questions and answering them



# Simple code for simple questions====
# Who are the 10 youngest medalists?
sdf %>%
  slice_min(age, n = 10, with_ties = FALSE)

# What about the 10 oldest?
sdf %>%
  slice_max(age, n = 10, with_ties = FALSE)


# Any Americans that I recognize?
sdf %>%
  filter(team == 'United States' & year > 1920 & sport == 'Basketball') %>%
  arrange(desc(games))
#====
