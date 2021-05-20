library(tidyverse)
library(skimr)

survey <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-18/survey.csv')

US_surveys <- survey %>%
  filter(country %in% c('United States', 'USA', 'US', 'U.S.', 'Usa'))

US_surveys
  



survey %>%
  rename(education = highest_level_of_education_completed,
         overall_experience = overall_years_of_professional_experience,
         field_experience = years_of_experience_in_field)

colnames(survey)

survey %>%
  count(industry, sort = TRUE)

survey %>%
  count(gender, race, sort = TRUE)

skim(survey)
