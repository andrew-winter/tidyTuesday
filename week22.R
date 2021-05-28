 # I'm going to try to use the new pipe with the Mario Kart world record data
library(tidyverse)
library(scales)
library(skimr)

records <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-25/records.csv')
drivers <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-25/drivers.csv')


skim(records)

records

records %>%
  group_split(type, shortcut)

# It's very easy to create out-of-the-box charts
records %>%
  ggplot(aes(date, time)) +
  geom_smooth() +
  facet_wrap(vars(type))

# Want to find a progression of the fastest timesa
# First have to find fastest times

unique(records$track)

records %>%
  filter(track %in% c('Mario Raceway') & shortcut == 'No') %>%
  group_split(type) %>%
  map(arrange, date) 

raceway_records <- records %>%
  filter(track %in% c('Mario Raceway') & shortcut == 'No')

# Simple way to do a complexer viz
raceway_records %>%
  ggplot(aes(date, time)) +
  geom_line(aes(color = system_played)) +
  facet_grid(vars(type))


unique(records$track)

records %>%
  filter(type == 'Three Lap' &
           track %in% c('Mario Raceway', 'Luigi Raceway', 'Wario Stadium',
                        'Rainbow Road', "Bowser's Castle")) %>%
  ggplot(aes(date, time)) +
  geom_line(aes(color = system_played)) +
  facet_grid(vars(track))

# Why do the world records go up over time, even after considering
# system_played and type


# Rainbow Road is one example

rainbow_records <- records %>%
  filter(type == 'Three Lap' & track == 'Rainbow Road')


arrange(rainbow_records, date) %>%
  group_split(system_played) %>%
  map(print, n = 50)

# I forgot to account for shortcut at least