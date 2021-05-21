library(tidyverse)
library(skimr)

survey <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-18/survey.csv')

US_surveys <- survey %>%
  filter(country %in% c('United States', 'USA', 'US', 'U.S.', 'Usa')) %>%
  rename(education = highest_level_of_education_completed,
         overall_experience = overall_years_of_professional_experience,
         field_experience = years_of_experience_in_field)


US_surveys

# US_surveys %>%
#  filter(annual_salary < 245000) %>%
#  ggplot() + geom_histogram(aes(annual_salary, fill = country))










str_detect_low <- function(str, pat, neg = FALSE) {
  # wrapper function for str_detect, pseudo case-insensitive
  # just supply a lower case pattern to the lower case string(s)
  
  str_detect(tolower(str), pat, negate = neg)
}


US_surveys_alt <- US_surveys %>%
  mutate(
    new_category = case_when(
      str_detect_low(industry, 'educ') ~ 'Education',
      str_detect_low(industry, 'resea') ~ 'Research',
      str_detect_low(industry, 'health') ~ 'Health',
      str_detect_low(industry, 'marketing') | 
        str_detect_low(industry, 'media ') ~ 'Advertising, Marketing, & Media',
      str_detect_low(industry, 'aero') ~ 'Aerospace',
      str_detect_low(industry, 'lib') ~ 'Libraries',
      str_detect_low(industry, 'admin') | 
        str_detect_low(industry, 'gov') ~ 'Administration & Government',
      TRUE ~ industry
    )
  )

US_surveys_alt

US_surveys_alt %>%
  count(new_category, sort = TRUE) %>%
  print(n = 200)


US_surveys_alt %>%
  select(industry, new_category) %>%
  filter(str_detect_low(new_category, 'gov')) %>%
  count(new_category, sort = TRUE) %>%
  print(n = 50)



survey_small <-  US_surveys_alt %>%
  count(new_category) %>%
  filter(n < 10)


survey_big <- US_surveys_alt %>%
  count(new_category) %>%
  filter(n >= 10)


survey_small

survey_big