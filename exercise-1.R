
if (!require(dplyr)) install.packages("dplyr")
if (!require(tidyr)) install.packages("tidyr")
if (!require(openxlsx)) install.packages("openxlsx")

library(dplyr)
library(tidyr)
library(openxlsx)

# 6. Source the styles sheet

# CSV file obtained from NISRA data portal https://data.nisra.gov.uk/table/MYE01T09

# Data read in as csv
data <- read.csv("mid-year-population-estimates-2022.csv") %>%
  # Total rows removed to avoid double counting
  filter(Sex != "All" & Local.Government.District != "Northern Ireland") %>%
  # Create a new grouped age variable
  mutate(`Age group` = case_when(Age < 25 ~ "Under 25",
                                 Age < 35 ~ "25-34",
                                 Age < 45 ~ "35-44",
                                 Age < 55 ~ "45-54",
                                 TRUE ~ "55 and over"),
         # Apply ordering of grouped age variable
         `Age group` = factor(`Age group`, levels = c("Under 25", "25-34", "35-44", "45-54", "55 and over"))) %>%
  # Use select to keep and rename some variables
  select(Year,
         `Local Government District` = Local.Government.District,
         Sex = Sex.Label,
         `Age group`,
         VALUE)

# Pivot data using new age group variable
by_age <- data %>%
  group_by(Year, `Age group`) %>%
  summarise(VALUE = sum(VALUE)) %>%
  pivot_wider(names_from = Year, values_from = VALUE)

# 1. Create a new workbook, 
# give it the title "Population Estimates" 
# and the subject "Demography Statistics" 
wb <- createWorkbook()

# 2. Name sheet 1 and add to workbook

# 7. Set default font option

# 3. Write a title for the sheet

# 8. Change the title to size 14 and bold

# 4. Write a title for the table

# 9. Change the title to bold

# 5. Write the data frame by_age out as a table

# 10. Change the first row heading back to aligned left

# 11. Change the figures to have comma formatting


saveWorkbook(wb, "mid-year-population-summary-2022-ex-1.xlsx", overwrite = TRUE)
openXL("mid-year-population-summary-2022-ex-1.xlsx")
