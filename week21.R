library(tidyverse)
library(skimr)

survey <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-18/survey.csv')

US_surveys <- survey %>%
  filter(country %in% c('United States', 'USA', 'US', 'U.S.', 'Usa')) %>%
  rename(education = highest_level_of_education_completed,
         overall_experience = overall_years_of_professional_experience,
         field_experience = years_of_experience_in_field)


US_surveys

US_surveys %>%
  filter(annual_salary < 245000) %>%
  ggplot() + geom_histogram(aes(annual_salary, fill = country))







US_surveys_alt <- US_surveys %>%
  mutate(
    new_category = case_when(
      str_detect(industry, 'educ') ~ 'Education',
      str_detect(industry, 'resea') ~ 'Research',
      str_detect(tolower(industry), tolower('health')) ~ 'Health',
      TRUE ~ industry
    )
  )

US_surveys_alt %>%
  count(new_category, sort = TRUE)


US_surveys_alt2 <- US_surveys_alt %>%
  filter(str_detect(tolower(industry), tolower('health')))



US_surveys_alt2 %>%
  filter(str_detect(tolower(industry), tolower('health'))) %>%
  count(industry, sort = TRUE)





str_detect_case <- function(s, p, n = FALSE) str_detect(s, p, negate = n)


US_surveys_alt3 <- US_surveys %>%
  mutate(
    new_category = case_when(
      str_detect(industry, 'educ') ~ 'Education',
      str_detect(industry, 'resea') ~ 'Research',
      str_detect_case(industry, 'health') ~ 'Health',
      TRUE ~ industry
    )
  )

US_surveys_alt3 %>%
  count(new_category, sort = TRUE)


# Not sure to what degree I have to use tolower()



US_surveys_alt %>%
  filter(str_detect(tolower(industry), tolower('resea'))) %>%
  count(industry, sort = TRUE) %>%
  print(n = 50)



US_surveys_alt %>%
  count(new_category, sort = TRUE) %>%
  print(n = 200)



colnames(survey)

survey %>%
  count(industry, sort = TRUE)

survey %>%
  count(gender, race, sort = TRUE)

skim(survey)
