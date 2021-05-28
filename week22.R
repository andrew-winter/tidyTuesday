# Set up----
# Want to try to use the new pipe |> w Mario Kart world record data
# Not worth it-- R 4.1.0 only, very slightly faster, no placeholder even
library(dplyr)
library(purrr)
library(ggplot2)
# library(scales) I'll load it when I need it
library(skimr)

records <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-25/records.csv')
drivers <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-25/drivers.csv')

skim(records)
records

# It's very easy to create out-of-the-box charts----
records %>%
  ggplot(aes(date, time)) +
  geom_smooth() +
  facet_wrap(vars(type))

# Mario Raceway example
raceway_records <- records %>%
  filter(track %in% c('Mario Raceway') & shortcut == 'No')

# Simple way to do a complexer viz
raceway_records %>%
  ggplot(aes(date, time)) +
  geom_line(aes(color = system_played)) +
  facet_grid(vars(type))


# Initial exploration----
# Want to find a progression of the fastest times
# First have to find fastest times
# Want to find if the dates in order are the same as the times in order
# Have to separate out by type, shortcut, track

records %>%
  count(track, sort = TRUE)
kart_tracks <- unique(records$track)

# Group_split returns a list separated by different categories
records %>%
  filter(track %in% c('Mario Raceway') & shortcut == 'No') %>%
  group_split(type) %>%
  map(arrange, date) 

# How the ggplot will look-ish at the beginning----
records %>%
  filter(type == 'Three Lap' &
           track %in% c('Mario Raceway', 'Luigi Raceway', 'Wario Stadium',
                        'Rainbow Road', "Bowser's Castle")) %>%
  ggplot(aes(date, time)) +
  geom_line(aes(color = system_played)) +
  facet_grid(vars(track))

# Investigating what other variables to account for----
# Why do the world records go up over time, even after considering
# system_played and type


# Rainbow Road is one example
rainbow_records <- records %>%
  filter(type == 'Three Lap' & track == 'Rainbow Road')

arrange(rainbow_records, date) %>%
  group_split(system_played) %>%
  map(print, n = 50)

# I forgot to account for shortcut at least----




rainbow_records %>%
  ggplot(aes(date, time)) +
  geom_line(aes(color = system_played)) +
  facet_wrap(vars(track, shortcut)) # Put track on by default


rainbow_records %>%
  group_split(system_played, shortcut) %>%
  map(arrange)





# Want to count how many records there are per system_played and shortcut
records %>%
  filter(type == 'Three Lap') %>%
  group_split(system_played, shortcut, track)
