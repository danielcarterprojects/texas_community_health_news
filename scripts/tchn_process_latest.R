setwd("~/Documents/Academics/TCHN")

library('tidyverse')
library('stringr')

counties = read.csv('raw_data/counties.csv')


######################################
# COUNTY POPULATIONS
#
# Historical is from here:
# https://www.census.gov/data/datasets/time-series/demo/popest/2010s-counties-total.html
#
# From 2020 on, we're using the ACS 5-year estimates. This file gets updated below.
#
#######################################

county_populations = read_csv(
  'raw_data/county_populations_historical.csv'
)



######################################
# MERGE ACS DATA
#
# Gets updated from acs_pull.R
#
#######################################

acs_data = read.csv('raw_data/acs_data_latest.csv')

acs_data$County.Code = as.character(acs_data$County.Code)
acs_data$County.Code = str_pad(acs_data$County.Code, 3, pad="0")
acs_data$County.Code = paste(
  "48",
  acs_data$County.Code,
  sep=""
)
acs_data$County.Code = as.integer(acs_data$County.Code)

counties = merge(counties, acs_data, by.x = 'fips', by.y = 'County.Code', all.x = TRUE)

rm(acs_data)

counties = counties %>% rename(
  "Hispanic_Percent" = "ACS5Y2020_Hispanic_Percent",
  "Education_Highschool_Percent" = "ACS5Y2020_Highschool_Percent",
  "Education_GED_Percent" = "ACS5Y2020_GED_Percent",
  "Education_Bachelors_Percent" = "ACS5Y2020_Bachelors_Percent",
  "Education_Masters_Percent" = "ACS5Y2020_Masters_Percent",
  "Education_Professional_Percent" = "ACS5Y2020_Professional_Percent",
  "Education_Doctorate_Percent" = "ACS5Y2020_Doctorate_Percent",
  "SNAP_Percent" = "ACS5Y2020_SNAP_Percent",
  "Median_Household_Income" = "ACS5Y2020_Median.Household.Income",
  "GINI_Index" = "ACS5Y2020_GINI_Index",
  "Unemployment_Percent" = "ACS5Y2020_Unemployment_Percent",
  "Poverty_Percent" = "ACS5Y2020_Poverty_Percent"
)

counties = select(counties, -c('X'))





######################################
# UPDATE COUNTY POPULATIONS FILE
#
# Update the county_populations_historical.csv file each time we pull the ACS data
#
#
#######################################

# ****** VARIABLE ******
# ****** VARIABLE ******
# ****** VARIABLE ******

# UPDATE THIS EVERY TIME YOU PULL NEW ACS DATA

county_populations$`2021` = counties$Population

# Save out county population file
write.csv(county_populations, file="raw_data/county_populations_historical.csv", row.names=FALSE)


######################################
# PROCESS AND MERGE SUICIDE DATA
#
# Gets downloaded manually every year from:
# https://healthdata.dshs.texas.gov/dashboard/births-and-deaths/deaths
#
# Cause of death: intentional self-harm (both)
#
#######################################

# Read
tdshs_suicide_2015 = read.csv('raw_data/tdshs/tdshs_suicide_2015.csv')
tdshs_suicide_2016 = read.csv('raw_data/tdshs/tdshs_suicide_2016.csv')
tdshs_suicide_2017 = read.csv('raw_data/tdshs/tdshs_suicide_2017.csv')
tdshs_suicide_2018 = read.csv('raw_data/tdshs/tdshs_suicide_2018.csv')
tdshs_suicide_2019 = read.csv('raw_data/tdshs/tdshs_suicide_2019.csv')
tdshs_suicide_2020 = read.csv('raw_data/tdshs/tdshs_suicide_2020.csv')

tdshs_suicide_2015$Year = 2015
tdshs_suicide_2016$Year = 2016
tdshs_suicide_2017$Year = 2017
tdshs_suicide_2018$Year = 2018
tdshs_suicide_2019$Year = 2019
tdshs_suicide_2020$Year = 2020


# Merge
tdshs_suicide = rbind(
  tdshs_suicide_2015,
  tdshs_suicide_2016,
  tdshs_suicide_2017,
  tdshs_suicide_2018,
  tdshs_suicide_2019,
  tdshs_suicide_2020
  )

# Reduce
tdshs_suicide = select(tdshs_suicide, c(X,All.Deaths,Year))
tdshs_suicide = tdshs_suicide %>% rename(
  County = X,
  Deaths_Suicide = All.Deaths
)

# Fix columns
tdshs_suicide$Deaths_Suicide = as.numeric(tdshs_suicide$Deaths_Suicide)

# Reduce to latest year and merge
tdshs_suicide_latest =  tdshs_suicide %>% 
  filter(Year == max(Year))

tdshs_suicide_latest = select(tdshs_suicide_latest, -c('Year'))

tmp_by = join_by('Name' == 'County')
counties = left_join(counties, tdshs_suicide_latest, tmp_by )

# Make logitudinal and save
tdshs_suicide_longitudinal = pivot_wider(
  tdshs_suicide,
  names_from = Year,
  values_from = Deaths_Suicide
)

tdshs_suicide_longitudinal = tdshs_suicide_longitudinal %>% arrange(
  County
)

write.csv(
  tdshs_suicide_longitudinal, 
  file = 'output/data/tdshs_suicide_logitudinal.csv', 
  row.names = FALSE
)

write.csv(
  tdshs_suicide, 
  file = 'output/data/tdshs_suicide_long.csv', 
  row.names = FALSE
)

# Clean up
rm(
  tdshs_suicide_2015,
  tdshs_suicide_2016,
  tdshs_suicide_2017,
  tdshs_suicide_2018,
  tdshs_suicide_2019,
  tdshs_suicide_2020,
  tdshs_suicide_latest,
  tdshs_suicide_longitudinal,
  tdshs_suicide
)




######################################
# PROCESS AND MERGE BIRTH DEFECT DATA
#
# Gets downloaded manually every year from:
# https://healthdata.dshs.texas.gov/dashboard/births-and-deaths/birth-defects
#
# Birth defects by county -> Body System = total
#
#######################################

# Read
tdshs_birth_defects_2013 = read.csv('raw_data/tdshs/tdshs_birth_defects_all_2013.csv')
tdshs_birth_defects_2014 = read.csv('raw_data/tdshs/tdshs_birth_defects_all_2014.csv')
tdshs_birth_defects_2015 = read.csv('raw_data/tdshs/tdshs_birth_defects_all_2015.csv')
tdshs_birth_defects_2016 = read.csv('raw_data/tdshs/tdshs_birth_defects_all_2016.csv')
tdshs_birth_defects_2017 = read.csv('raw_data/tdshs/tdshs_birth_defects_all_2017.csv')

# Merge
tdshs_birth_defects = rbind(tdshs_birth_defects_2013, tdshs_birth_defects_2014, tdshs_birth_defects_2015, tdshs_birth_defects_2016, tdshs_birth_defects_2017)

# Reduce
tdshs_birth_defects = select(tdshs_birth_defects, c(`County.Name`, `YearText`,`Prevalence.per.10.000.Live.Births.along.`))

# Fix columns
tdshs_birth_defects$Prevalence.per.10.000.Live.Births.along. = as.numeric(tdshs_birth_defects$Prevalence.per.10.000.Live.Births.along.)

tdshs_birth_defects = tdshs_birth_defects %>% rename(
  "Birth_Defects_Per_10k" = "Prevalence.per.10.000.Live.Births.along."
)

# Reduce to latest year and merge
tdshs_birth_defects_latest =  tdshs_birth_defects %>% 
                              filter(YearText == max(YearText))

tdshs_birth_defects_latest = select(tdshs_birth_defects_latest, -c('YearText'))

tmp_by = join_by('Name' == 'County.Name')
counties = left_join(counties, tdshs_birth_defects_latest, tmp_by )

# Make logitudinal and save
tdshs_birth_defects_longitudinal = pivot_wider(
                              tdshs_birth_defects,
                              names_from = YearText,
                              values_from = Birth_Defects_Per_10k
)

write.csv(
  tdshs_birth_defects_longitudinal, 
  file = 'output/data/tdshs_birth_defects_logitudinal.csv', 
  row.names = FALSE
)

write.csv(
  tdshs_birth_defects, 
  file = 'output/data/tdshs_birth_defects_long.csv', 
  row.names = FALSE
)

# Clean up
rm(
  tdshs_birth_defects_2013,
  tdshs_birth_defects_2014,
  tdshs_birth_defects_2015,
  tdshs_birth_defects_2016,
  tdshs_birth_defects_2017,
  tdshs_birth_defects_latest,
  tdshs_birth_defects_longitudinal,
  tdshs_birth_defects
)












######################################
# INFANT MORTALITY DATA
#
# Gets downloaded manually every year from:
# https://healthdata.dshs.texas.gov/dashboard/births-and-deaths/infant-deaths
#
# Custom data table - race/ethnicity, select year
#
#######################################

# Read
tdshs_infant_deaths_2019 = read.csv('raw_data/tdshs/tdshs_infant_deaths_2019.csv')
tdshs_infant_deaths_2018 = read.csv('raw_data/tdshs/tdshs_infant_deaths_2018.csv')
tdshs_infant_deaths_2017 = read.csv('raw_data/tdshs/tdshs_infant_deaths_2017.csv')
tdshs_infant_deaths_2016 = read.csv('raw_data/tdshs/tdshs_infant_deaths_2016.csv')
tdshs_infant_deaths_2015 = read.csv('raw_data/tdshs/tdshs_infant_deaths_2015.csv')

# Add year col
tdshs_infant_deaths_2019$Year = 2019
tdshs_infant_deaths_2018$Year = 2018
tdshs_infant_deaths_2017$Year = 2017
tdshs_infant_deaths_2016$Year = 2016
tdshs_infant_deaths_2015$Year = 2015

# Merge
tdshs_infant_deaths = rbind(
  tdshs_infant_deaths_2019,
  tdshs_infant_deaths_2018,
  tdshs_infant_deaths_2017,
  tdshs_infant_deaths_2016,
  tdshs_infant_deaths_2015
)

# Rename
tdshs_infant_deaths = tdshs_infant_deaths %>% rename (
  County = X,
  Black = Non.Hispanic.Black,
  Other = Non.Hispanic.Other,
  White = Non.Hispanic.White
)

# Fix columns
tdshs_infant_deaths$Hispanic = as.numeric(tdshs_infant_deaths$Hispanic)
tdshs_infant_deaths$Black = as.numeric(tdshs_infant_deaths$Black)
tdshs_infant_deaths$White = as.numeric(tdshs_infant_deaths$White)
tdshs_infant_deaths$Other = as.numeric(tdshs_infant_deaths$Other)

# Reduce to latest year and merge
tdshs_infant_deaths_latest =  tdshs_infant_deaths %>% 
  filter(Year == max(Year))

tdshs_infant_deaths_latest = select(tdshs_infant_deaths_latest, -c('Year'))

tdshs_infant_deaths_latest = tdshs_infant_deaths_latest %>% rename (
  Infant_Deaths_Hispanic = Hispanic,
  Infant_Deaths_Black = Black,
  Infant_Deaths_White = White,
  Infant_Deaths_Other = Other
)

tdshs_infant_deaths_latest = tdshs_infant_deaths_latest %>% relocate(
  Infant_Deaths_Black,
  Infant_Deaths_Hispanic,
  Infant_Deaths_Other,
  Infant_Deaths_White
)

tmp_by = join_by('Name' == 'County')
counties = left_join(counties, tdshs_infant_deaths_latest, tmp_by )

# Make long
tdshs_infant_deaths_long = tdshs_infant_deaths %>% pivot_longer(
  -c(County, Year),
  names_to = "Race",
  values_to = "Infant_Deaths"
)

# Make wide
tdshs_infant_deaths_longitudinal = tdshs_infant_deaths_long %>% pivot_wider(
  names_from = c(Year),
  values_from = Infant_Deaths
)

write.csv(
  tdshs_infant_deaths_longitudinal, 
  file = 'output/data/tdshs_infant_deaths_longitudinal.csv', 
  row.names = FALSE
)

write.csv(
  tdshs_infant_deaths_long, 
  file = 'output/data/tdshs_infant_deaths_long.csv', 
  row.names = FALSE
)

# Clean up
rm(list = ls(, pattern = "tdshs_infant_deaths"))









######################################           Unfinished
# HEALTHCARE PROVIDERS
#
# Gets downloaded manually every year from:
# https://data.hrsa.gov/topics/health-workforce/ahrf
#
# Select category and Texas. Actual years are listed in source column.
#
#######################################

hrsa_md_2020 = read.csv('raw_data/hrsa/hrsa_md_2020.csv')






######################################           Unfinished
# COMMUNITY RESILIENCE
#
# Gets downloaded manually every year(?) from:
# https://www.census.gov/programs-surveys/community-resilience-estimates/data/datasets.html
#
# Download county file.
#
#######################################

census_comm_resilience_estimates_2019 = read.csv('raw_data/census/census_comm_resilience_estimates_2019.csv')







######################################        UNFINISHED
# PROCESS AND MERGE NEW HIV CASE DATA -
#
# Gets downloaded manually every year from:
# https://healthdata.dshs.texas.gov/dashboard/diseases/new-hiv-diagnoses-summary
#
# Download crosstab for all cases with all selected for each option
# Per email: Rate represents cases per 100,000 population in each jurisdiction.
#
#######################################

tdshs_hiv_cases_new = read.csv('raw_data/tdshs/tdshs_hiv_cases_new.csv')

# Remove Texas
tdshs_hiv_cases_new = tdshs_hiv_cases_new %>% filter(
  Area != "Texas"
)

tdshs_hiv_cases_new = tdshs_hiv_cases_new %>% rename (
  "County" = "Area",
  "2010" = "X2010",
  "2011" = "X2011",
  "2012" = "X2012",
  "2013" = "X2013",
  "2014" = "X2014",
  "2015" = "X2015",
  "2016" = "X2016",
  "2017" = "X2017",
  "2018" = "X2018",
  "2019" = "X2019"
)

# Filter for only all cases - remove demographics
tdshs_hiv_cases_new_all = tdshs_hiv_cases_new %>% filter(
  Age.group == "All",
  Race == "All",
  Sex == "All",
  X == "Rate"
)

tdshs_hiv_cases_new_all = tdshs_hiv_cases_new_all %>% select(-c(
  Age.group,
  Race,
  Sex,
  X
))

# Filter for Black
tdshs_hiv_cases_new_black = tdshs_hiv_cases_new %>% filter(
  Age.group == "All",
  Race == "Black",
  Sex == "All",
  X == "Rate"
)

tdshs_hiv_cases_new_black = tdshs_hiv_cases_new_black %>% select(-c(
  Age.group,
  Race,
  Sex,
  X
))

##### DANIEL - HAVE TO FINISH THIS. Which races? How to format and package? Still need to merge in. 










######################################
# EXPORT
#
# Write the new tchn_latest.csv file
#
#######################################

write.csv(counties, file="output/data/tchn_latest.csv", row.names = FALSE)
write.csv(
  counties, 
  file=paste(
    "output/data/tchn_", 
    format(Sys.time(), "%Y%m%d"), 
    ".csv",
    collapse = "",
    sep="") 
)

