#https://rpubs.com/rosenblum_jeff/censustutorial1

setwd("~/Documents/Academics/TCHN")

library(tidyverse)
library(readxl)
library(acs)
library(stringr)

api.key.install(key="9925cc88cedfbda155532ef9c85d5a64888d85d3")


### GET FIPS CODES
counties = read.csv("raw_data/counties.csv")


## SETUP ACS VARIABLES THAT WE WANT

acs.tables.install()

span = 5
endyear = 2021
geo_counties = geo.make(state=48, county=as.numeric(str_sub(counties$fips,start = -3)))

table_population = acs.lookup(endyear = endyear, table.number="B01003")
#results(mytable)$variable.name
var_population_total = table_population[1]

table_hispanic = acs.lookup(endyear = endyear, table.number="B03002")
#results(mytable)$variable.name
var_hispanic_total = table_hispanic[1]
var_hispanic = table_hispanic[12]

table_poverty = acs.lookup(endyear = endyear, table.number="B17001")
var_poverty_total = table_poverty[1]
var_poverty = table_poverty[2]

table_gini = acs.lookup(endyear = endyear, table.number="B19083")
var_gini = table_gini[1]

table_education = acs.lookup(endyear = endyear, table.number="B15003")
var_education_total = table_education[1]
var_highschool = table_education[17]
var_ged = table_education[18]
var_bachelors = table_education[22]
var_masters = table_education[23]
var_professional_degree = table_education[24]
var_doctorate = table_education[25]

table_snap = acs.lookup(endyear = endyear, table.number="B22001")
var_snap_total = table_snap[1]
var_snap = table_snap[2]

table_employment = acs.lookup(endyear = endyear, table.number="B23025")
var_employment_total = table_employment[3]
var_unemployed = table_employment[5]

table_income = acs.lookup(endyear = endyear, table.number="B19013")
var_median_household_income = table_income[1]

acs_variables = c(
  var_hispanic_total,
  var_hispanic,
  var_poverty_total,
  var_poverty,
  var_gini,
  var_education_total,
  var_highschool,
  var_ged,
  var_bachelors,
  var_masters,
  var_professional_degree,
  var_doctorate,
  var_snap_total,
  var_snap,
  var_employment_total,
  var_unemployed,
  var_median_household_income,
  var_population_total
  )



## GET THE ACS DATA

acs_data = acs.fetch(
  endyear=endyear, 
  span=span, 
  geography=geo_counties, 
  variable=acs_variables
  )

##
# [1] "B03002_001" "B03002_012" "B17001_001" "B17001_002" "B19083_001" "B15003_001" "B15003_017"
# [8] "B15003_018" "B15003_022" "B15003_023" "B15003_024" "B15003_025" "B22001_001" "B22001_002"
# [15] "B23025_003" "B23025_005" "B19013_001" "B01003_001"

tmp_hispanic_percent = acs_data@estimate[,2] / acs_data@estimate[,1]
tmp_poverty_percent = acs_data@estimate[,4] / acs_data@estimate[,3]
tmp_highschool_percent = acs_data@estimate[,7] / acs_data@estimate[,6]
tmp_ged_percent = acs_data@estimate[,8] / acs_data@estimate[,6]
tmp_bachelors_percent = acs_data@estimate[,9] / acs_data@estimate[,6]
tmp_masters_percent = acs_data@estimate[,10] / acs_data@estimate[,6]
tmp_professional_percent = acs_data@estimate[,11] / acs_data@estimate[,6]
tmp_doctorate_percent = acs_data@estimate[,12] / acs_data@estimate[,6]
tmp_snap_percent = acs_data@estimate[,14] / acs_data@estimate[,13]
tmp_unemployment_percent = acs_data@estimate[,16] / acs_data@estimate[,15]

acs_county_data = data.frame(
  acs_data@geography$county,
  acs_data@estimate[,18], # Total population
  tmp_hispanic_percent, # Hispanic percent
  tmp_poverty_percent, # Poverty percent
  acs_data@estimate[,5], # GINI index
  tmp_highschool_percent, # Highschool percent
  tmp_ged_percent, # ged percent
  tmp_bachelors_percent, # bachelors percent
  tmp_masters_percent, # masters percent
  tmp_professional_percent, # professional percent
  tmp_doctorate_percent, # doctorate percent
  tmp_snap_percent, # snap percent
  tmp_unemployment_percent, # unemployment percent
  acs_data@estimate[,17] # median household income
)

colnames(acs_county_data) = c(
  'County Code',
  'Population',
  'ACS5Y2020_Hispanic_Percent',
  'ACS5Y2020_Poverty_Percent',
  'ACS5Y2020_GINI_Index',
  'ACS5Y2020_Highschool_Percent',
  'ACS5Y2020_GED_Percent',
  'ACS5Y2020_Bachelors_Percent',
  'ACS5Y2020_Masters_Percent',
  'ACS5Y2020_Professional_Percent',
  'ACS5Y2020_Doctorate_Percent',
  'ACS5Y2020_SNAP_Percent',
  'ACS5Y2020_Unemployment_Percent',
  'ACS5Y2020_Median Household Income'
  )


write.csv(acs_county_data, file="raw_data/acs_data_latest.csv")
write.csv(
  acs_county_data, 
  file=paste(
    "raw_data/acs_data_", 
    format(Sys.time(), "%Y%m%d"), 
    ".csv",
    collapse = "",
    sep="") 
  )
