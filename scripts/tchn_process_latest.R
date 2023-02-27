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
# SDOH Data
#
# Download yearly from https://www.ahrq.gov/sdoh/data-analytics/sdoh-data.html
#
# !!!!! MANUAL UPDATE !!!!!
# The goal is for this to run mostly on its own, but we'll have to keep an eye on variable changes. 
# Annual update should pay close attention to this section.
#
#######################################

sdoh_2020 = read_csv('raw_data/sdoh/sdoh_2020.csv')

sdoh_2020 = sdoh_2020 %>% filter(
  STATE == "Texas"
)

sdoh_2020_variables = c(
  "YEAR",
  "COUNTYFIPS",
  "COUNTY",
  "ACS_TOT_POP_WT",
  "ACS_PCT_HH_LIMIT_ENGLISH",
  "ACS_PCT_VET",
  "ACS_MEDIAN_AGE",
  "ACS_PCT_AGE_0_17",
  "ACS_PCT_AGE_ABOVE65",
  "ACS_PCT_ASIAN",
  "ACS_PCT_BLACK",
  "ACS_PCT_HISPANIC",
  "ACS_PCT_WHITE",
  "ACS_PCT_HH_NO_COMP_DEV",
  "ACS_PCT_HH_SMARTPHONE_ONLY",
  "ACS_PCT_HH_NO_INTERNET",
  "ACS_GINI_INDEX",
  "ACS_MEDIAN_HH_INC_ASIAN",
  "ACS_MEDIAN_HH_INC_BLACK",
  "ACS_MEDIAN_HH_INC_HISP",
  "ACS_MEDIAN_HH_INC_WHITE",
  "ACS_MEDIAN_HH_INC",
  "ACS_PCT_PERSON_INC_BELOW99",
  "ACS_PCT_POV_ASIAN",
  "ACS_PCT_POV_BLACK",
  "ACS_PCT_POV_HISPANIC",
  "ACS_PCT_POV_WHITE",
  "ACS_PCT_HH_FOOD_STMP",
  "ACS_PCT_COLLEGE_ASSOCIATE_DGR",
  "ACS_PCT_BACHELOR_DGR",
  "ACS_PCT_GRADUATE_DGR",
  "ACS_PCT_HS_GRADUATE",
  "ACS_PCT_LT_HS",
  "ACS_MEDIAN_HOME_VALUE",
  "ACS_MEDIAN_RENT",
  "ACS_PCT_COMMT_15MIN",
  "ACS_PCT_COMMT_29MIN",
  "ACS_PCT_COMMT_59MIN",
  "ACS_PCT_COMMT_60MINUP",
  "ACS_PCT_HU_NO_VEH",
  "ACS_PCT_MEDICAID_ANY",
  "ACS_PCT_MEDICARE_ONLY",
  "ACS_PCT_OTHER_INS",
  "ACS_PCT_UNINSURED",
  "AHRF_UNEMPLOYED_RATE",
  "AHRF_PCT_GOOD_AQ",
  "AHRF_TXC_SITE_NO_DATA",
  "AHRF_TXC_SITE_CNTRL",
  "AHRF_TXC_SITE_NO_CNTRL",
  "AHRF_HPSA_DENTIST",
  "AHRF_HPSA_MENTAL",
  "AHRF_HPSA_PRIM",
  "AHRF_DENTISTS_RATE",
  "AHRF_NURSE_PRACT_RATE",
  "AHRF_PHYSICIAN_ASSIST_RATE",
  "AMFAR_SSP_RATE",
  "AMFAR_MEDSAFAC_RATE",
  "AMFAR_AMATFAC_RATE",
  "AMFAR_MEDMHFAC_RATE",
  "AMFAR_MHFAC_RATE",
  "CDCW_INJURY_DTH_RATE",
  "CDCW_TRANSPORT_DTH_RATE",
  "CDCW_SELFHARM_DTH_RATE",
  "CDCW_ASSAULT_DTH_RATE",
  "CDCW_MATERNAL_DTH_RATE",
  "CDCW_OPIOID_DTH_RATE",
  "CDCW_DRUG_DTH_RATE",
  "CHR_MENTAL_PROV_RATE",
  "NCHS_URCS_2013",
  "HIFLD_MEDIAN_DIST_UC",
  "HIFLD_UC_RATE",
  "LTC_AVG_OBS_REHOSP_RATE",
  "LTC_AVG_OBS_SUCCESSFUL_DISC_RATE",
  'LTC_OCCUPANCY_RATE',
  'LTC_PCT_FOR_PROFIT',
  'LTC_PCT_MULTI_FAC',
  "MMD_ANXIETY_DISD",
  "MMD_BIPOLAR_DISD",
  "MMD_DEPR_DISD",
  "MMD_PERSONALITY_DISD",
  "MMD_OUD_IND",
  "PC_PCT_MEDICARE_APPRVD_FULL_AMT",
  "POS_MEDIAN_DIST_ED",
  "POS_MEDIAN_DIST_MEDSURG_ICU",
  "POS_MEDIAN_DIST_TRAUMA",
  "POS_MEDIAN_DIST_PED_ICU",
  "POS_MEDIAN_DIST_OBSTETRICS",
  "POS_MEDIAN_DIST_CLINIC",
  "POS_MEDIAN_DIST_ALC",
  "POS_FQHC_RATE",
  "POS_CMHC_RATE",
  "POS_RHC_RATE",
  "POS_HHA_RATE",
  "POS_HOSPICE_RATE",
  "POS_NF_RATE",
  "POS_NF_BEDS_RATE",
  "POS_SNF_RATE",
  "POS_SNF_BEDS_RATE",
  "POS_PCT_HOSP_FOR_PROFIT",
  "POS_PCT_HOSP_NON_PROFIT",
  "POS_PCT_HOSP_GOV"
)

sdoh_2020 = sdoh_2020 %>% select(
  all_of(sdoh_2020_variables)
)

# Update this if we start doing longitudinal
sdoh_all = sdoh_2020

sdoh_all$COUNTY = str_replace(sdoh_all$COUNTY, " County", "")

tmp_latest_year = max(sdoh_all$YEAR)

sdoh_latest =  sdoh_all %>% 
  filter(YEAR == tmp_latest_year)

county_populations[[paste("X.",tmp_latest_year,sep="",collapse="")]] = sdoh_latest$ACS_TOT_POP_WT

write.csv(county_populations, file="raw_data/county_populations_historical.csv", row.names=FALSE)

# FUTURE WORK
# FUTURE WORK
# FUTURE WORK
# Make longitudinal here, if we want to.

tmp_by = join_by('Name' == 'COUNTY')
counties = left_join(counties, sdoh_latest, tmp_by )

# Clean up
counties = counties %>% select(
  !c(YEAR,COUNTYFIPS)
)

# METADATA
# METADATA
# METADATA
# Have to update this each year we pull

sdoh_2020_metadata = read_csv('raw_data/sdoh/sdoh_2020_variables.csv')

sdoh_2020_metadata = sdoh_2020_metadata %>% filter(
  name %in% sdoh_2020_variables
) %>% select (
  c(name,label)
)

sdoh_2020_metadata$source = ""
sdoh_2020_metadata$source_link = ""
sdoh_2020_metadata$notes = ""
sdoh_2020_metadata$year = 2020

sdoh_standard_note = "Included data were obtained from the U.S. Department of Health and Human Services Agency for Healthcare Research and Quality's Social Determinants of Health Database. The SDOH database compiles data from many departments and organizations. The indicated year refers to the SDOH release; however, for some variables SDOH data may reflect a previous year due to idiosyncratic release schedules. For full information on SDOH variables, refer to https://www.ahrq.gov/sdoh/data-analytics/sdoh-data.html."

sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^ACS"),]$source = "U.S. Census Bureau American Community Survey 5-Year Estimates"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^ACS"),]$source_link = "https://www.census.gov/data/developers/data-sets/acs-5year.html"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^ACS"),]$notes = "Included data were obtained from the U.S. Department of Health and Human Services Agency for Healthcare Research and Quality's Social Determinants of Health Database. Data reflects the 5-year estimate ending with the indicated year."

# ******* #

sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^AHRF"),]$source = "U.S. Department of Health and Human Services Area Health Resource Files"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^AHRF"),]$source_link = "https://data.hrsa.gov/topics/health-workforce/ahrf"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^AHRF"),]$notes = sdoh_standard_note

# ******* #

sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^AMFAR"),]$source = "amfAR, The Foundation for AIDS Research"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^AMFAR"),]$source_link = "https://www.amfar.org/"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^AMFAR"),]$notes = sdoh_standard_note

# ******* #

sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^CDCW"),]$source = "Centers for Disease Control and Prevention Wide-ranging Online Data for Epidemiologic Research (CDCW)"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^CDCW"),]$source_link = "https://wonder.cdc.gov/"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^CDCW"),]$notes = sdoh_standard_note

# ******* #

sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^CHR"),]$source = "University of Wisconsin Population Health Institute and the Robert Wood Johnson Foundation's County Health Rankings (CHR)"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^CHR"),]$source_link = "https://uwphi.pophealth.wisc.edu/chrr/"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^CHR"),]$notes = sdoh_standard_note

# ******* #

sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^NCHS"),]$source = "National Center for Health Statistics"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^NCHS"),]$source_link = "https://www.cdc.gov/nchs/data_access/urban_rural.htm"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^NCHS"),]$notes = sdoh_standard_note

# ******* #

sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^NHC"),]$source = "U.S. Department of Health and Human Services, Centers for Medicare & Medicaid Services"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^NHC"),]$source_link = "https://www.medicare.gov/care-compare/?providerType=NursingHome&redirect=true"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^NHC"),]$notes = sdoh_standard_note

# ******* #

sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^HIFLD"),]$source = "U.S. Department of Homeland Security"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^HIFLD"),]$source_link = "https://hifld-geoplatform.opendata.arcgis.com/datasets/urgent-care-facilities/explore"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^HIFLD"),]$notes = sdoh_standard_note

# ******* #

sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^LTC"),]$source = "National Institute on Aging through a cooperative agreement with the Brown University School of Public Health"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^LTC"),]$source_link = "https://ltcfocus.org/"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^LTC"),]$notes = sdoh_standard_note

# ******* #

sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^MMD"),]$source = "U.S. Department of Health and Human Services, Office of Minority Health, Centers for Medicare & Medicaid Services (CMS)"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^MMD"),]$source_link = "https://data.cms.gov/tools/mapping-medicare-disparities-by-population"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^MMD"),]$notes = sdoh_standard_note

# ******* #

sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^PC_"),]$source = "U.S. Department of Health and Human Services, Centers for Medicare & Medicaid Services"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^PC_"),]$source_link = "https://data.cms.gov/provider-data/archived-data/doctors-clinicians"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^PC_"),]$notes = sdoh_standard_note

# ******* #

sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^POS_"),]$source = "U.S. Department of Health and Human Services, Centers for Medicare & Medicaid Services"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^POS_"),]$source_link = "https://www.cms.gov/Research-Statistics-Data-and-Systems/Downloadable-Public-Use-Files/Provider-of-Services"
sdoh_2020_metadata[str_detect(sdoh_2020_metadata$name, "^POS_"),]$notes = sdoh_standard_note

# Create var for all metadata
counties_metadata = sdoh_2020_metadata

# Delete vars
rm(list = ls(, pattern = "sdoh_"))
rm(list = ls(, pattern = "tmp_"))









###################################### 
# CDC PLACES Data
#
# Download yearly from https://chronicdata.cdc.gov/browse?category=500+Cities+%26+Places&sortBy=newest&utf8
# https://www.cdc.gov/places/social-determinants-of-health-and-places-data/index.html
#
# Update annually. Keep an eye on variable changes over time.
#
#######################################

cdc_places_2022 = read_csv('raw_data/cdc/cdc_places_2022.csv')

cdc_places_2022 = cdc_places_2022 %>% filter(
  StateDesc == "Texas"  
)

# **** #

cdc_obsesity_prevalence = cdc_places_2022 %>% filter(
  Measure == "Obesity among adults aged >=18 years",
  Data_Value_Type == "Crude prevalence"
) %>% select(
  Year, 
  LocationName,
  Data_Value
) %>% arrange(
  LocationName
)

counties$BRFSS_OBESITY_RATE = cdc_obsesity_prevalence$Data_Value

tmp_metadata = c(
  "BRFSS_OBESITY_RATE",
  "Obesity rate among adults aged >=18 years",
  "Centers for Disease Control and Prevention Behavioral Risk Factor Surveillance System",
  "https://www.cdc.gov/brfss/index.html",
  "Included data were obtained from PLACES, a collaboration between the CDC, the Robert Wood Johnson Foundation, and the CDC Foundation.",
  2020
)

counties_metadata = rbind(counties_metadata, tmp_metadata)

# **** #

cdc_drinking_prevalence = cdc_places_2022 %>% filter(
  Measure == "Binge drinking among adults aged >=18 years",
  Data_Value_Type == "Crude prevalence"
) %>% select(
  Year, 
  LocationName,
  Data_Value
) %>% arrange(
  LocationName
)

counties$BRFSS_BINGE_DRINKING_RATE = cdc_drinking_prevalence$Data_Value

tmp_metadata = c(
  "BRFSS_BINGE_DRINKING_RATE",
  "Binge drinking rate among adults aged >=18 years",
  "Centers for Disease Control and Prevention Behavioral Risk Factor Surveillance System",
  "https://www.cdc.gov/brfss/index.html",
  "Included data were obtained from PLACES, a collaboration between the CDC, the Robert Wood Johnson Foundation, and the CDC Foundation. The CDC defines binge drinking as consuming 5 or more drinks on an occasion for men or 4 or more drinks on an occasion for women.",
  2020
)

counties_metadata = rbind(counties_metadata, tmp_metadata)

# **** #

cdc_smoking_prevalence = cdc_places_2022 %>% filter(
  Measure == "Current smoking among adults aged >=18 years",
  Data_Value_Type == "Crude prevalence"
) %>% select(
  Year, 
  LocationName,
  Data_Value
) %>% arrange(
  LocationName
)

counties$BRFSS_SMOKING_RATE = cdc_smoking_prevalence

tmp_metadata = c(
  "BRFSS_SMOKING_RATE",
  "Current smoking rate among adults aged >=18 years",
  "Centers for Disease Control and Prevention Behavioral Risk Factor Surveillance System",
  "https://www.cdc.gov/brfss/index.html",
  "Included data were obtained from PLACES, a collaboration between the CDC, the Robert Wood Johnson Foundation, and the CDC Foundation.",
  2020
)

counties_metadata = rbind(counties_metadata, tmp_metadata)

# **** #

cdc_depression_prevalence = cdc_places_2022 %>% filter(
  Measure == "Depression among adults aged >=18 years",
  Data_Value_Type == "Crude prevalence"
) %>% select(
  Year, 
  LocationName,
  Data_Value
) %>% arrange(
  LocationName
)

counties$BRFSS_DEPRESSION_RATE = cdc_depression_prevalence

tmp_metadata = c(
  "BRFSS_DEPRESSION_RATE",
  "Depression rate among adults aged >=18 years",
  "Centers for Disease Control and Prevention Behavioral Risk Factor Surveillance System",
  "https://www.cdc.gov/brfss/index.html",
  "Included data were obtained from PLACES, a collaboration between the CDC, the Robert Wood Johnson Foundation, and the CDC Foundation.",
  2020
)

counties_metadata = rbind(counties_metadata, tmp_metadata)

# **** #

cdc_diabetes_prevalence = cdc_places_2022 %>% filter(
  Measure == "Diagnosed diabetes among adults aged >=18 years",
  Data_Value_Type == "Crude prevalence"
) %>% select(
  Year, 
  LocationName,
  Data_Value
) %>% arrange(
  LocationName
)

counties$BRFSS_DIABETES_RATE = cdc_diabetes_prevalence

tmp_metadata = c(
  "BRFSS_DIABETES_RATE",
  "Diagnosed diabetes rate among adults aged >=18 years",
  "Centers for Disease Control and Prevention Behavioral Risk Factor Surveillance System",
  "https://www.cdc.gov/brfss/index.html",
  "Included data were obtained from PLACES, a collaboration between the CDC, the Robert Wood Johnson Foundation, and the CDC Foundation.",
  2020
)

counties_metadata = rbind(counties_metadata, tmp_metadata)

# Delete vars
rm(list = ls(, pattern = "cdc_"))
rm(list = ls(, pattern = "tmp_"))






###################################### 
# CDC/ATSDR Social Vulnerability Index
#
# Download yearly from https://www.atsdr.cdc.gov/placeandhealth/svi/data_documentation_download.html
#
# Current variables:
# 
# Socioeconomic Status - RPL_THEME1
# Household Characteristics - RPL_THEME2
# Racial & Ethnic Minority Status - RPL_THEME3
# Housing Type & Transportation - RPL_THEME4
# Overall Rankings - RPL_THEMES
#
#######################################

cdc_atsdr_2020 = read_csv('raw_data/cdc_atsdr/cdc_atsdr_social_vulnerability_2020.csv')

cdc_atsdr_overall = cdc_atsdr_2020 %>% select(
  RPL_THEMES
)

cdc_atsdr_socioeconomic = cdc_atsdr_2020 %>% select(
  RPL_THEME1
)

cdc_atsdr_household = cdc_atsdr_2020 %>% select(
  RPL_THEME2
)

cdc_atsdr_racial = cdc_atsdr_2020 %>% select(
  RPL_THEME3
)

cdc_atsdr_housing = cdc_atsdr_2020 %>% select(
  RPL_THEME4
)

counties$CDC_ATSDR_SOC_VUL_OVERALL = cdc_atsdr_overall
counties$CDC_ATSDR_SOC_VUL_SOCIOECONOMIC = cdc_atsdr_socioeconomic
counties$CDC_ATSDR_SOC_VUL_HOUSEHOLD = cdc_atsdr_household
counties$CDC_ATSDR_SOC_VUL_RACE_ETHNICITY = cdc_atsdr_racial
counties$CDC_ATSDR_SOC_VUL_HOUSING_TRANSPORT = cdc_atsdr_housing

tmp_note = "The CDC/ATSDR Social Vulnerability Index ranks counties' social vulnerability along four dimensions: socioeconomic status, household characteristics, racial and ethnic minority status and housing type and transportation. An overall ranking combines these dimensions. Rankings are relative to all U.S. counties, and higher numbers indicate greater vulnerability. According to the CDC/ATSDR, social Vulnerability refers to the resilience of communities (the ability to survive and thrive) when confronted by external stresses on human health, stresses such as natural or human-caused disasters, or disease outbreaks."

tmp_metadata = c(
  "CDC_ATSDR_SOC_VUL_OVERALL",
  "Overall social vulnerability ranking",
  "Centers for Disease Control and Prevention, Agency for Toxic Substances and Disease Registry",
  "https://www.atsdr.cdc.gov/placeandhealth/svi/at-a-glance_svi.html",
  tmp_note,
  2020
)

counties_metadata = rbind(counties_metadata, tmp_metadata)

# **** #

tmp_metadata = c(
  "CDC_ATSDR_SOC_VUL_SOCIOECONOMIC",
  "Socioeconomic social vulnerability ranking",
  "Centers for Disease Control and Prevention, Agency for Toxic Substances and Disease Registry",
  "https://www.atsdr.cdc.gov/placeandhealth/svi/at-a-glance_svi.html",
  tmp_note,
  2020
)

counties_metadata = rbind(counties_metadata, tmp_metadata)

# *** #

tmp_metadata = c(
  "CDC_ATSDR_SOC_VUL_HOUSEHOLD",
  "Household characteristics social vulnerability ranking",
  "Centers for Disease Control and Prevention, Agency for Toxic Substances and Disease Registry",
  "https://www.atsdr.cdc.gov/placeandhealth/svi/at-a-glance_svi.html",
  tmp_note,
  2020
)

counties_metadata = rbind(counties_metadata, tmp_metadata)

# *** #

tmp_metadata = c(
  "CDC_ATSDR_SOC_VUL_RACE_ETHNICITY",
  "Racial and ethnic minority status social vulnerability ranking",
  "Centers for Disease Control and Prevention, Agency for Toxic Substances and Disease Registry",
  "https://www.atsdr.cdc.gov/placeandhealth/svi/at-a-glance_svi.html",
  tmp_note,
  2020
)

counties_metadata = rbind(counties_metadata, tmp_metadata)

# *** #

tmp_metadata = c(
  "CDC_ATSDR_SOC_VUL_HOUSING_TRANSPORT",
  "Housing type and transportation social vulnerability ranking",
  "Centers for Disease Control and Prevention, Agency for Toxic Substances and Disease Registry",
  "https://www.atsdr.cdc.gov/placeandhealth/svi/at-a-glance_svi.html",
  tmp_note,
  2020
)

counties_metadata = rbind(counties_metadata, tmp_metadata)

# Delete vars
rm(list = ls(, pattern = "cdc_"))
rm(list = ls(, pattern = "tmp"))







######################################
# BIRTH DEFECTS
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
  "TDSHS_BIRTH_DEFECTS_RATE" = "Prevalence.per.10.000.Live.Births.along."
)

tmp_max_year = max(tdshs_birth_defects$YearText)

# Reduce to latest year and merge
tdshs_birth_defects_latest =  tdshs_birth_defects %>% 
                              filter(YearText == max(YearText))

tdshs_birth_defects_latest = select(tdshs_birth_defects_latest, -c('YearText'))

tmp_by = join_by('Name' == 'County.Name')
counties = left_join(counties, tdshs_birth_defects_latest, tmp_by )

# Metadata

tmp_metadata = c(
  "TDSHS_BIRTH_DEFECTS_RATE",
  "Rate of birth defects per 10,000 live births",
  "Texas Department of State Health Services",
  "https://healthdata.dshs.texas.gov/dashboard/births-and-deaths/birth-defects",
  "",
  tmp_max_year
)

counties_metadata = rbind(counties_metadata, tmp_metadata)



# Make logitudinal and save
tdshs_birth_defects_longitudinal = pivot_wider(
                              tdshs_birth_defects,
                              names_from = YearText,
                              values_from = TDSHS_BIRTH_DEFECTS_RATE
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

# Delete vars
rm(list = ls(, pattern = "tdshs_"))
rm(list = ls(, pattern = "tmp"))












######################################      
# ALCOHOL SERVING ESTABLISHMENTS
#
# Gets downloaded manually every year from:
# https://www.census.gov/programs-surveys/cbp/data/datasets.html
#
# Open in Refine. 
# fipstate = 48
# naics code = 722410
# export csv
#
# !! MANUAL UPDATE !!
# Processing requires a merge with population file.
#
#######################################

census_cbp_alc_est_2020 = read_csv('raw_data/census/census_cbp_alc_est_2020.csv')

# !!! MANUAL UPDATE FOR POPULATION PULL !!! #
tmp_year = 2020

# Format fips
census_cbp_alc_est_2020$fipscty = str_pad(
  census_cbp_alc_est_2020$fipscty,
  3,
  pad = "0"
)

census_cbp_alc_est_2020$fips = str_c(
  census_cbp_alc_est_2020$fipstate,
  census_cbp_alc_est_2020$fipscty,
  sep=""
)

census_cbp_alc_est_2020 = census_cbp_alc_est_2020 %>% select(
  fips,
  est
)

census_cbp_alc_est_2020$fips = as.numeric(census_cbp_alc_est_2020$fips)

# Merge county name in order to merge population

tmp_by = join_by('fips' == 'fips')
census_cbp_alc_est_2020 = left_join(census_cbp_alc_est_2020, counties[,c('Name','fips')], tmp_by )


tmp_by = join_by('Name' == 'County')
census_cbp_alc_est_2020 = left_join(census_cbp_alc_est_2020, county_populations[,c('County',str_c('X.',tmp_year,collapse=""))], tmp_by )

census_cbp_alc_est_2020$Alc.Establisments.per.100k = census_cbp_alc_est_2020$est / census_cbp_alc_est_2020$X.2020 * 100000

census_cbp_alc_est_2020 = census_cbp_alc_est_2020 %>% select(
  fips,
  Alc.Establisments.per.100k
)

tmp_by = join_by('fips' == 'fips')
counties = left_join(counties, census_cbp_alc_est_2020, tmp_by )

# Metadata

tmp_metadata = c(
  "Alc.Establisments.per.100k",
  "Number of primarily alcohol-serving establishments per 100,000 population",
  "U.S. Census County Business Patterns",
  "https://www.census.gov/programs-surveys/cbp.html",
  "",
  2020
)

counties_metadata = rbind(counties_metadata, tmp_metadata)

# Delete vars
rm(list = ls(, pattern = "census_"))
rm(list = ls(, pattern = "tmp"))











######################################      
# TRAFFIC FATALITIES PER 100k
#
# Gets downloaded manually every year(?) from:
# https://cdan.dot.gov/query
#
# Filter for state. Rows: State and County | Columns: BAC: Highest Driver BAC
# Easier to use an extention to save the HTML table instead of downloading.
# Delete first row of data.
#
# !! MANUAL UPDATE !!
# Processing requires a merge with population file.
#
#######################################

nhtsa_traffic_fatalities_2020 = read.csv('raw_data/nhtsa/nhtsa_traffic_fatalities_2020.csv')

nhtsa_traffic_fatalities_2020$State.County = str_replace(
  nhtsa_traffic_fatalities_2020$State.County,
  "Texas - ",
  "")

# Remove first row
nhtsa_traffic_fatalities_2020 = nhtsa_traffic_fatalities_2020[-1,]

tmp_by = join_by('State.County' == 'County')
nhtsa_traffic_fatalities_2020 = left_join(nhtsa_traffic_fatalities_2020, county_populations[,c('County', 'X.2020')], tmp_by )

nhtsa_traffic_fatalities_2020$Total = as.numeric(nhtsa_traffic_fatalities_2020$Total)
nhtsa_traffic_fatalities_2020$BAC..08..g.dL = as.numeric(nhtsa_traffic_fatalities_2020$BAC..08..g.dL)

# Calculate rates per 100k population
nhtsa_traffic_fatalities_2020$rate_all = nhtsa_traffic_fatalities_2020$Total / nhtsa_traffic_fatalities_2020$X.2020 * 100000

nhtsa_traffic_fatalities_2020$rate_bac_08 = nhtsa_traffic_fatalities_2020$BAC..08..g.dL / nhtsa_traffic_fatalities_2020$X.2020 * 100000

nhtsa_traffic_fatalities_2020 = nhtsa_traffic_fatalities_2020 %>% select(
  State.County,
  rate_all,
  rate_bac_08
)

colnames(nhtsa_traffic_fatalities_2020) = c(
  'County',
  'NHTSA_TRAFF_FATALITIES_RATE',
  'NHTSA_TRAFF_FATALITIES_BAC_08_RATE'
)

tmp_by = join_by('Name' == 'County')
counties = left_join(counties, nhtsa_traffic_fatalities_2020, tmp_by )


# Metadata

tmp_metadata = c(
  "NHTSA_TRAFF_FATALITIES_RATE",
  "Rate of traffic fatalities per 100,000 population",
  "National Highway Traffic Safety Administration",
  "https://cdan.dot.gov/query",
  "",
  2020
)

counties_metadata = rbind(counties_metadata, tmp_metadata)

tmp_metadata = c(
  "NHTSA_TRAFF_FATALITIES_BAC_08_RATE",
  "Rate of traffic fatalities involving a driver with BAC > 0.8 per 100,000 population",
  "National Highway Traffic Safety Administration",
  "https://cdan.dot.gov/query",
  "",
  2020
)

counties_metadata = rbind(counties_metadata, tmp_metadata)

# Delete vars
rm(list = ls(, pattern = "nhtsa_"))
rm(list = ls(, pattern = "tmp"))












######################################      
# OPIOID DISPENSING RATES
#
# Gets downloaded manually every year(?) from:
# https://www.cdc.gov/drugoverdose/rxrate-maps/index.html
#
# Save HTML table and filter below. 
#
#######################################

cdc_opioid_dispensing_rates_2020 = read_csv("raw_data/cdc/cdc_opioid_dispensing_rates_2020.csv")

cdc_opioid_dispensing_rates_2020 = cdc_opioid_dispensing_rates_2020 %>% filter(
  State == "TX"
) %>% select(
  `County FIPS Code`,
  `Opioid Dispensing Rate per 100`
) %>% rename (
  "Opioid.Dispensing.Rate.per.100" = "Opioid Dispensing Rate per 100"
)

tmp_by = join_by('fips' == 'County FIPS Code')
counties = left_join(counties, cdc_opioid_dispensing_rates_2020, tmp_by )

# Metadata

tmp_metadata = c(
  "Opioid.Dispensing.Rate.per.100",
  "Rate of traffic fatalities involving a driver with BAC > 0.8 per 100,000 population",
  "Centers for Disease Control",
  "https://www.cdc.gov/drugoverdose/rxrate-maps/index.html",
  "In this context, the CDC defines a prescription as a new or refill prescription dispensed at a retail pharmacy in the sample and paid for by commercial insurance, Medicaid, Medicare, cash or its equivalent, and other third-party coverage. Mail order prescriptions are not included.",
  2020
)

counties_metadata = rbind(counties_metadata, tmp_metadata)

# Delete vars
rm(list = ls(, pattern = "cdc_"))
rm(list = ls(, pattern = "tmp"))










######################################      
# HEALTHCARE PROFESSIONS
#
# Gets downloaded manually every year(?) from:
# https://www.dshs.texas.gov/health-professions-resource-center-hprc/health-professions
#
# Save HTML tables. 
#
#######################################

tdshs_professions_lbsw = read_csv('raw_data/tdshs/tdshs_professions_lbsw_2020.csv')
tdshs_professions_lcdc = read_csv('raw_data/tdshs/tdshs_professions_lcdc_2020.csv')
tdshs_professions_lcsw = read_csv('raw_data/tdshs/tdshs_professions_lcsw_2020.csv')
tdshs_professions_lmsw = read_csv('raw_data/tdshs/tdshs_professions_lmsw_2020.csv')
tdshs_professions_lpc = read_csv('raw_data/tdshs/tdshs_professions_lpc_2020.csv')
tdshs_professions_pcp = read_csv('raw_data/tdshs/tdshs_professions_pcp_2020.csv')

tdshs_professions_lbsw = tdshs_professions_lbsw %>% select(
  c(1,5)
) %>% rename(
  "LBSWs.per.100k" = "Ratio of LBSWs to 100,000 Population"
)

tdshs_professions_lcdc = tdshs_professions_lcdc %>% select(
  c(1,5)
) %>% rename(
  "LCDCs.per.100k" = "Ratio of LCDCs to 100,000 Population"
)

tdshs_professions_lcsw = tdshs_professions_lcsw %>% select(
  c(1,5)
) %>% rename(
  "LCSWs.per.100k" = "Ratio of LCSWs to 100,000 Population"
)

tdshs_professions_lmsw = tdshs_professions_lmsw %>% select(
  c(1,5)
) %>% rename(
  "LMSWs.per.100k" = "Ratio of LMSWs to 100,000 Population"
)

tdshs_professions_lpc = tdshs_professions_lpc %>% select(
  c(1,5)
) %>% rename(
  "LPCs.per.100k" = "Ratio of LPCs to 100,000 Population"
)

tdshs_professions_pcp = tdshs_professions_pcp %>% select(
  c(1,5)
) %>% rename(
  "PCPs.per.100k" = "Ratio of Primary Care Physicians to 100,000 Population"
)

tmp_by = join_by('Name' == 'County')
counties = left_join(counties, tdshs_professions_pcp, tmp_by )

tmp_by = join_by('Name' == 'County')
counties = left_join(counties, tdshs_professions_lcdc, tmp_by )

tmp_by = join_by('Name' == 'County')
counties = left_join(counties, tdshs_professions_lpc, tmp_by )

tmp_by = join_by('Name' == 'County')
counties = left_join(counties, tdshs_professions_lcsw, tmp_by )

tmp_by = join_by('Name' == 'County')
counties = left_join(counties, tdshs_professions_lbsw, tmp_by )

tmp_by = join_by('Name' == 'County')
counties = left_join(counties, tdshs_professions_lmsw, tmp_by )

# Metadata

tmp_source = "Texas Department of State Health Services"
tmp_link = "https://www.dshs.texas.gov/health-professions-resource-center-hprc/health-professions"
tmp_year = 2020

tmp_metadata = c(
  "PCPs.per.100k",
  "Primary care physicians per 100,000 people.",
  tmp_source,
  tmp_link,
  "",
  tmp_year
)

counties_metadata = rbind(counties_metadata, tmp_metadata)

# *** #

tmp_metadata = c(
  "LCDCs.per.100k",
  "Licensed chemical dependency counselors per 100,000 people.",
  tmp_source,
  tmp_link,
  "",
  tmp_year
)

counties_metadata = rbind(counties_metadata, tmp_metadata)

# *** #

tmp_metadata = c(
  "LPCs.per.100k",
  "Licensed professional counselors per 100,000 people.",
  tmp_source,
  tmp_link,
  "",
  tmp_year
)

counties_metadata = rbind(counties_metadata, tmp_metadata)

# *** #

tmp_metadata = c(
  "LCSWs.per.100k",
  "Licensed clinical social workers per 100,000 people.",
  tmp_source,
  tmp_link,
  "",
  tmp_year
)

counties_metadata = rbind(counties_metadata, tmp_metadata)

# *** #

tmp_metadata = c(
  "LBSWs.per.100k",
  "Licensed bachelor-level social workers per 100,000 people.",
  tmp_source,
  tmp_link,
  "",
  tmp_year
)

counties_metadata = rbind(counties_metadata, tmp_metadata)

# *** #

tmp_metadata = c(
  "LMSWs.per.100k",
  "Licensed masters-level social workers per 100,000 people.",
  tmp_source,
  tmp_link,
  "",
  tmp_year
)

counties_metadata = rbind(counties_metadata, tmp_metadata)

# Delete vars
rm(list = ls(, pattern = "tdshs_"))
rm(list = ls(, pattern = "tmp"))



  
  
  
  
  
  
  
  
  
  














######################################
# ORGANIZE METADATA
#
#
#######################################

counties_metadata = counties_metadata %>% filter(
  name != "YEAR"
)

counties_metadata[counties_metadata$name %in% c('COUNTYFIPS','COUNTY'),]$year = ""

category_general = c(
  'COUNTYFIPS',
  'COUNTY',
  'ACS_TOT_POP_WT',
  'CDC_ATSDR_SOC_VUL_OVERALL',
  'CDC_ATSDR_SOC_VUL_SOCIOECONOMIC',
  'CDC_ATSDR_SOC_VUL_HOUSEHOLD',
  'CDC_ATSDR_SOC_VUL_RACE_ETHNICITY',
  'CDC_ATSDR_SOC_VUL_HOUSING_TRANSPORT'
)

category_social_context = c(
  'CDC_ATSDR_SOC_VUL_RACE_ETHNICITY',
  'ACS_PCT_HH_LIMIT_ENGLISH',
  'ACS_PCT_VET',
  'ACS_MEDIAN_AGE',
  'ACS_PCT_AGE_0_4',
  'ACS_PCT_AGE_5_9',
  'ACS_PCT_AGE_10_14',
  'ACS_PCT_AGE_15_17',
  'ACS_PCT_AGE_0_17',
  'ACS_PCT_AGE_18_29',
  'ACS_PCT_AGE_18_44',
  'ACS_PCT_AGE_30_44',
  'ACS_PCT_AGE_45_64',
  'ACS_PCT_AGE_50_64',
  'ACS_PCT_AGE_ABOVE65',
  'ACS_PCT_ASIAN',
  'ACS_PCT_BLACK',
  'ACS_PCT_HISPANIC',
  'ACS_PCT_WHITE'
)





category_economic_context = c(
  'ACS_GINI_INDEX',
  'ACS_MEDIAN_HH_INC_ASIAN',
  'ACS_MEDIAN_HH_INC_BLACK',
  'ACS_MEDIAN_HH_INC_HISP',
  'ACS_MEDIAN_HH_INC_WHITE',
  'ACS_MEDIAN_HH_INC',
  'ACS_PCT_PERSON_INC_BELOW99',
  'ACS_PCT_POV_ASIAN',
  'ACS_PCT_POV_BLACK',
  'ACS_PCT_POV_HISPANIC',
  'ACS_PCT_POV_WHITE',
  'ACS_PCT_HH_FOOD_STMP',
  'ACS_MEDIAN_HOME_VALUE',
  'ACS_MEDIAN_RENT',
  'AHRF_UNEMPLOYED_RATE'
  
)



category_education = c(
  'ACS_PCT_COLLEGE_ASSOCIATE_DGR',
  'ACS_PCT_BACHELOR_DGR',
  'ACS_PCT_GRADUATE_DGR',
  'ACS_PCT_HS_GRADUATE',
  'ACS_PCT_LT_HS'
)


category_physical_infrastructure = c(
  'ACS_PCT_HH_NO_COMP_DEV',
  'ACS_PCT_HH_SMARTPHONE_ONLY',
  'ACS_PCT_HH_NO_INTERNET',
  'ACS_PCT_COMMT_15MIN',
  'ACS_PCT_COMMT_29MIN',
  'ACS_PCT_COMMT_59MIN',
  'ACS_PCT_COMMT_60MINUP',
  'ACS_PCT_HU_NO_VEH',
  'AHRF_PCT_GOOD_AQ',
  'AHRF_TXC_SITE_NO_DATA',
  'AHRF_TXC_SITE_CNTRL',
  'AHRF_TXC_SITE_NO_CNTRL',
  'NCHS_URCS_2013',
  'NHTSA_TRAFF_FATALITIES_RATE',
  'NHTSA_TRAFF_FATALITIES_BAC_08_RATE',
  'Alc.Establisments.per.100k'
)


category_healthcare_context = c(
  'ACS_PCT_MEDICAID_ANY',
  'ACS_PCT_MEDICARE_ONLY',
  'ACS_PCT_OTHER_INS',
  'ACS_PCT_UNINSURED',
  'AHRF_HPSA_DENTIST',
  'AHRF_HPSA_MENTAL',
  'AHRF_HPSA_PRIM',
  'AHRF_DENTISTS_RATE',
  'AHRF_NURSE_PRACT_RATE',
  'AHRF_PHYSICIAN_ASSIST_RATE',
  'AMFAR_SSP_RATE',
  'AMFAR_MEDSAFAC_RATE',
  'AMFAR_AMATFAC_RATE',
  'AMFAR_MEDMHFAC_RATE',
  'AMFAR_MHFAC_RATE',
  'CDCW_INJURY_DTH_RATE',
  'CDCW_TRANSPORT_DTH_RATE',
  'CDCW_SELFHARM_DTH_RATE',
  'CDCW_ASSAULT_DTH_RATE',
  'CDCW_MATERNAL_DTH_RATE',
  'CDCW_OPIOID_DTH_RATE',
  'CDCW_DRUG_DTH_RATE',
  'CHR_MENTAL_PROV_RATE',
  'HIFLD_MEDIAN_DIST_UC',
  'HIFLD_UC_RATE',
  'LTC_AVG_OBS_REHOSP_RATE',
  'LTC_AVG_OBS_SUCCESSFUL_DISC_RATE',
  'LTC_OCCUPANCY_RATE',
  'LTC_PCT_FOR_PROFIT',
  'LTC_PCT_MULTI_FAC',
  'MMD_ANXIETY_DISD',
  'MMD_BIPOLAR_DISD',
  'MMD_DEPR_DISD',
  'MMD_PERSONALITY_DISD',
  'MMD_OUD_IND',
  'PC_PCT_MEDICARE_APPRVD_FULL_AMT',
  'POS_MEDIAN_DIST_ED',
  'POS_MEDIAN_DIST_MEDSURG_ICU',
  'POS_MEDIAN_DIST_TRAUMA',
  'POS_MEDIAN_DIST_PED_ICU',
  'POS_MEDIAN_DIST_OBSTETRICS',
  'POS_MEDIAN_DIST_CLINIC',
  'POS_MEDIAN_DIST_ALC',
  'POS_FQHC_RATE',
  'POS_CMHC_RATE',
  'POS_RHC_RATE',
  'POS_HHA_RATE',
  'POS_HOSPICE_RATE',
  'POS_NF_RATE',
  'POS_NF_BEDS_RATE',
  'POS_SNF_RATE',
  'POS_SNF_BEDS_RATE',
  'POS_PCT_HOSP_FOR_PROFIT',
  'POS_PCT_HOSP_NON_PROFIT',
  'POS_PCT_HOSP_GOV',
  'BRFSS_OBESITY_RATE',
  'BRFSS_BINGE_DRINKING_RATE',
  'BRFSS_SMOKING_RATE',
  'BRFSS_DEPRESSION_RATE',
  'BRFSS_DIABETES_RATE',
  'BRFSS_DIABETES_RATE',
  'TDSHS_BIRTH_DEFECTS_RATE',
  'Opioid.Dispensing.Rate.per.100',
  'PCPs.per.100k',
  'LCDCs.per.100k',
  'LPCs.per.100k',
  'LCSWs.per.100k',
  'LBSWs.per.100k',
  'LMSWs.per.100k'
)

# Add category column

counties_metadata$category = ""
counties_metadata[counties_metadata$name %in% category_healthcare_context,]$category = "Healthcare Context"
counties_metadata[counties_metadata$name %in% category_physical_infrastructure,]$category = "Physical Infrastructure"
counties_metadata[counties_metadata$name %in% category_education,]$category = "Education"
counties_metadata[counties_metadata$name %in% category_economic_context,]$category = "Economic Context"
counties_metadata[counties_metadata$name %in% category_social_context,]$category = "Social Context"




# Rename variables
counties = counties %>% rename(
  'County' = 'Name',
  'FIPS.Code' = 'fips',
  'Population' = 'ACS_TOT_POP_WT',
  'Percent.Households_Limited_English' = 'ACS_PCT_HH_LIMIT_ENGLISH',
  'Percent.Veteran' = 'ACS_PCT_VET',
  'Median.Age' = 'ACS_MEDIAN_AGE',
  'Percent.Age.0.to.17' = 'ACS_PCT_AGE_0_17',
  'Percent.Age.Over.65' = 'ACS_PCT_AGE_ABOVE65',
  'Percent.Asian' = 'ACS_PCT_ASIAN',
  'Percent.Black' = 'ACS_PCT_BLACK',
  'Percent.Hispanic' = 'ACS_PCT_HISPANIC',
  'Percent.White' = 'ACS_PCT_WHITE',
  'Percent.Households.No.Computer.Device' = 'ACS_PCT_HH_NO_COMP_DEV',
  'Percent.Households.Smarphone.Only' = 'ACS_PCT_HH_SMARTPHONE_ONLY',
  'Percent.Households.No.Internet' = 'ACS_PCT_HH_NO_INTERNET',
  'GINI.Index' = 'ACS_GINI_INDEX',
  'Median.Household.Income.Asian' = 'ACS_MEDIAN_HH_INC_ASIAN',
  'Median.Household.Income.Black' = 'ACS_MEDIAN_HH_INC_BLACK',
  'Median.Household.Income.Hispanic' = 'ACS_MEDIAN_HH_INC_HISP',
  'Median.Household.Income.White' = 'ACS_MEDIAN_HH_INC_WHITE',
  'Median.Household.Income' = 'ACS_MEDIAN_HH_INC',
  'Percent.in.Poverty' = 'ACS_PCT_PERSON_INC_BELOW99',
  'Percent.in.Poverty.Asian' = 'ACS_PCT_POV_ASIAN',
  'Percent.in.Poverty.Black' = 'ACS_PCT_POV_BLACK',
  'Percent.in.Poverty.Hispanic' = 'ACS_PCT_POV_HISPANIC',
  'Percent.in.Poverty.White' = 'ACS_PCT_POV_WHITE',
  'Percent.Households.Food.Stamps' = 'ACS_PCT_HH_FOOD_STMP',
  'Percent.with.Associate.Degree' = 'ACS_PCT_COLLEGE_ASSOCIATE_DGR',
  'Percent.with.Bachelor.Degree' = 'ACS_PCT_BACHELOR_DGR',
  'Percent.with.Graduate.Degree' = 'ACS_PCT_GRADUATE_DGR',
  'Percent.Highschool.Graduate' = 'ACS_PCT_HS_GRADUATE',
  'Percent.Less.than.Highschool' = 'ACS_PCT_LT_HS',
  'Median.Home.Value' = 'ACS_MEDIAN_HOME_VALUE',
  'Median.Rent' = 'ACS_MEDIAN_RENT',
  'Percent.Commute.Less.than.15min' = 'ACS_PCT_COMMT_15MIN',
  'Percent.Commute.15min.to.29min' = 'ACS_PCT_COMMT_29MIN',
  'Percent.Commute.30min.to.59min' = 'ACS_PCT_COMMT_59MIN',
  'Percent.Commute.60min.or.More' = 'ACS_PCT_COMMT_60MINUP',
  'Percent.Housing.Units.No.Vehicle' = 'ACS_PCT_HU_NO_VEH',
  'Percent.Medicaid' = 'ACS_PCT_MEDICAID_ANY',
  'Percent.Medicare.Only' = 'ACS_PCT_MEDICARE_ONLY',
  'Percent.Health.Insurance.Other' = 'ACS_PCT_OTHER_INS',
  'Percent.No.Health.Insurance' = 'ACS_PCT_UNINSURED',
  'Percent.Unemployed' = 'AHRF_UNEMPLOYED_RATE',
  'Percent.Days.Good.Air.Quality' = 'AHRF_PCT_GOOD_AQ',
  'Toxic.Sites.Insufficient.Data' = 'AHRF_TXC_SITE_NO_DATA',
  'Toxic.Sites.Under.Control' = 'AHRF_TXC_SITE_CNTRL',
  'Toxic.Sites.Not.Under.Control' = 'AHRF_TXC_SITE_NO_CNTRL',
  'Dentist.Shortage.Code' = 'AHRF_HPSA_DENTIST',
  'Mental.Healthcare.Shortage.Code' = 'AHRF_HPSA_MENTAL',
  'Primary.Care.Shortage.Code' = 'AHRF_HPSA_PRIM',
  'Dentists.per.1k' = 'AHRF_DENTISTS_RATE',
  'Nurse.Practitioners.per.1k' = 'AHRF_NURSE_PRACT_RATE',
  'Physician.Assistants.per.1k' = 'AHRF_PHYSICIAN_ASSIST_RATE',
  'Syringe.Exchange.Programs.per.1k' = 'AMFAR_SSP_RATE',
  'Substance.Abuse.Facilities.Accepting.Medicare.per.1k' = 'AMFAR_MEDSAFAC_RATE',
  'Substance.Abuse.Facilities.per.1k' = 'AMFAR_AMATFAC_RATE',
  'Mental.Health.Facilities.Accepting.Medicare.per.1k' = 'AMFAR_MEDMHFAC_RATE',
  'Mental.Health.Facilities.per.1k' = 'AMFAR_MHFAC_RATE',
  'Deaths.from.Injury.per.100k' = 'CDCW_INJURY_DTH_RATE',
  'Deaths.from.Transport.Accident.per.100k' = 'CDCW_TRANSPORT_DTH_RATE',
  'Deaths.from.Suicide.per.100k' = 'CDCW_SELFHARM_DTH_RATE',
  'Deaths.from.Assault.per.100k' = 'CDCW_ASSAULT_DTH_RATE',
  'Maternal.Deaths.per.100k' = 'CDCW_MATERNAL_DTH_RATE',
  'Opioid.Overdose.Deaths.per.100k' = 'CDCW_OPIOID_DTH_RATE',
  'Drug.Poisoning.Deaths.per.100k' = 'CDCW_DRUG_DTH_RATE',
  'Mental.Health.Providers.per.100k' = 'CHR_MENTAL_PROV_RATE',
  'NCHS.Rural.Urban.Code' = 'NCHS_URCS_2013',
  'Median.Distance.to.Urgent.Care' = 'HIFLD_MEDIAN_DIST_UC',
  'Urgent.Care.Orgs.per.1k' = 'HIFLD_UC_RATE',
  'Average.Rehospitalization.Rate' = 'LTC_AVG_OBS_REHOSP_RATE',
  'Average.Successful.Discharge.Rate' = 'LTC_AVG_OBS_SUCCESSFUL_DISC_RATE',
  'Nursing.Home.Occupancy.Rate' = 'LTC_OCCUPANCY_RATE',
  'Percent.Nursing.Homes.For.Profit' = 'LTC_PCT_FOR_PROFIT',
  'Percent.Nursing.Homes.Chain' = 'LTC_PCT_MULTI_FAC',
  'Anxiety.Disorders.Rate.Medicare' = 'MMD_ANXIETY_DISD',
  'Bipolar.Disorder.Rate.Medicare' = 'MMD_BIPOLAR_DISD',
  'Depressive.Disorders.Rate.Medicare' = 'MMD_DEPR_DISD',
  'Personality.Disorders.Rate.Medicare' = 'MMD_PERSONALITY_DISD',
  'Opioid.Overuse.Disorder.Rate.Medicare' = 'MMD_OUD_IND',
  'Percent.Clinicians.Accpeting.Medicaid' = 'PC_PCT_MEDICARE_APPRVD_FULL_AMT',
  'Median.Distance.to.Emergency.Department' = 'POS_MEDIAN_DIST_ED',
  'Median.Distance.to.Medical.Surgical.ICU' = 'POS_MEDIAN_DIST_MEDSURG_ICU',
  'Median.Distance.to.Trauma.Center' = 'POS_MEDIAN_DIST_TRAUMA',
  'Median.Distance.to.Pediatric.ICU' = 'POS_MEDIAN_DIST_PED_ICU',
  'Median.Distance.to.Obstetrics.Department' = 'POS_MEDIAN_DIST_OBSTETRICS',
  'Median.Distance.to.Health.Clinic' = 'POS_MEDIAN_DIST_CLINIC',
  'Median.Distance.to.Alcohol.Drug.Incare' = 'POS_MEDIAN_DIST_ALC',
  'Health.Centers.per.1k' = 'POS_FQHC_RATE',
  'Community.Mental.Health.Centers.per.1k' = 'POS_CMHC_RATE',
  'Rural.Health.Clinics.per.1k' = 'POS_RHC_RATE',
  'Home.Health.Agencies.per.1k' = 'POS_HHA_RATE',
  'Hospices.per.1k' = 'POS_HOSPICE_RATE',
  'Nursing.Facilities.per.1k' = 'POS_NF_RATE',
  'Nursing.Facility.Beds.per.1k' = 'POS_NF_BEDS_RATE',
  'Skilled.Nursing.Facilities.per.1k' = 'POS_SNF_RATE',
  'Skilled.Nursing.Facility.Beds.per.1k' = 'POS_SNF_BEDS_RATE',
  'Percent.Hospitals.Private.For.Profit' = 'POS_PCT_HOSP_FOR_PROFIT',
  'Percent.Hospitals.Non.Profit' = 'POS_PCT_HOSP_NON_PROFIT',
  'Percent.Hospitals.Government' = 'POS_PCT_HOSP_GOV',
  'Obesity.Rate' = 'BRFSS_OBESITY_RATE',
  'Binge.Drinking.Rate' = 'BRFSS_BINGE_DRINKING_RATE',
  'Smoking.Rate' = 'BRFSS_SMOKING_RATE',
  'Depression.Rate' = 'BRFSS_DEPRESSION_RATE',
  'Diabetes.Rate' = 'BRFSS_DIABETES_RATE',
  'Overall.Social.Vulnerability' = 'CDC_ATSDR_SOC_VUL_OVERALL',
  'Socioeconomic.Social.Vulnerability' = 'CDC_ATSDR_SOC_VUL_SOCIOECONOMIC',
  'Household.Characteristics.Social.Vulnerability' = 'CDC_ATSDR_SOC_VUL_HOUSEHOLD',
  'Race.Ethnicity.Social.Vulnerability' = 'CDC_ATSDR_SOC_VUL_RACE_ETHNICITY',
  'Housing.Transport.Social.Vulnerability' = 'CDC_ATSDR_SOC_VUL_HOUSING_TRANSPORT',
  'Birth.Defects.per.10k' = 'TDSHS_BIRTH_DEFECTS_RATE',
  'Traffic.Fatalities.per.100k' = 'NHTSA_TRAFF_FATALITIES_RATE',
  'Traffic.Fatalities.BAC.08.per.100k' = 'NHTSA_TRAFF_FATALITIES_BAC_08_RATE'
)

counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'COUNTYFIPS',	'FIPS.Code'))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'COUNTY',	'County'))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_TOT_POP_WT',	'Population'))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_HH_LIMIT_ENGLISH',	'Percent.Households_Limited_English' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_VET',	'Percent.Veteran' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_MEDIAN_AGE',	'Median.Age' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_AGE_0_17',	'Percent.Age.0.to.17' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_AGE_ABOVE65',	'Percent.Age.Over.65' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_ASIAN',	'Percent.Asian' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_BLACK',	'Percent.Black' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_HISPANIC',	'Percent.Hispanic' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_WHITE',	'Percent.White' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_HH_NO_COMP_DEV',	'Percent.Households.No.Computer.Device' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_HH_SMARTPHONE_ONLY',	'Percent.Households.Smarphone.Only' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_HH_NO_INTERNET',	'Percent.Households.No.Internet' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_GINI_INDEX',	'GINI.Index' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_MEDIAN_HH_INC_ASIAN',	'Median.Household.Income.Asian' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_MEDIAN_HH_INC_BLACK',	'Median.Household.Income.Black' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_MEDIAN_HH_INC_HISP',	'Median.Household.Income.Hispanic' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_MEDIAN_HH_INC_WHITE',	'Median.Household.Income.White' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_MEDIAN_HH_INC',	'Median.Household.Income' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_PERSON_INC_BELOW99',	'Percent.in.Poverty' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_POV_ASIAN',	'Percent.in.Poverty.Asian' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_POV_BLACK',	'Percent.in.Poverty.Black' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_POV_HISPANIC',	'Percent.in.Poverty.Hispanic' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_POV_WHITE',	'Percent.in.Poverty.White' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_HH_FOOD_STMP',	'Percent.Households.Food.Stamps' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_COLLEGE_ASSOCIATE_DGR',	'Percent.with.Associate.Degree' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_BACHELOR_DGR',	'Percent.with.Bachelor.Degree' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_GRADUATE_DGR',	'Percent.with.Graduate.Degree' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_HS_GRADUATE',	'Percent.Highschool.Graduate' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_LT_HS',	'Percent.Less.than.Highschool' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_MEDIAN_HOME_VALUE',	'Median.Home.Value' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_MEDIAN_RENT',	'Median.Rent' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_COMMT_15MIN',	'Percent.Commute.Less.than.15min' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_COMMT_29MIN',	'Percent.Commute.15min.to.29min' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_COMMT_59MIN',	'Percent.Commute.30min.to.59min' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_COMMT_60MINUP',	'Percent.Commute.60min.or.More' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_HU_NO_VEH',	'Percent.Housing.Units.No.Vehicle' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_MEDICAID_ANY',	'Percent.Medicaid' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_MEDICARE_ONLY',	'Percent.Medicare.Only' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_OTHER_INS',	'Percent.Health.Insurance.Other' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'ACS_PCT_UNINSURED',	'Percent.No.Health.Insurance' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'AHRF_UNEMPLOYED_RATE',	'Percent.Unemployed' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'AHRF_PCT_GOOD_AQ',	'Percent.Days.Good.Air.Quality' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'AHRF_TXC_SITE_NO_DATA',	'Toxic.Sites.Insufficient.Data' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'AHRF_TXC_SITE_CNTRL',	'Toxic.Sites.Under.Control' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'AHRF_TXC_SITE_NO_CNTRL',	'Toxic.Sites.Not.Under.Control' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'AHRF_HPSA_DENTIST',	'Dentist.Shortage.Code' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'AHRF_HPSA_MENTAL',	'Mental.Healthcare.Shortage.Code' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'AHRF_HPSA_PRIM',	'Primary.Care.Shortage.Code' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'AHRF_DENTISTS_RATE',	'Dentists.per.1k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'AHRF_NURSE_PRACT_RATE',	'Nurse.Practitioners.per.1k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'AHRF_PHYSICIAN_ASSIST_RATE',	'Physician.Assistants.per.1k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'AMFAR_SSP_RATE',	'Syringe.Exchange.Programs.per.1k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'AMFAR_MEDSAFAC_RATE',	'Substance.Abuse.Facilities.Accepting.Medicare.per.1k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'AMFAR_AMATFAC_RATE',	'Substance.Abuse.Facilities.per.1k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'AMFAR_MEDMHFAC_RATE',	'Mental.Health.Facilities.Accepting.Medicare.per.1k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'AMFAR_MHFAC_RATE',	'Mental.Health.Facilities.per.1k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'CDCW_INJURY_DTH_RATE',	'Deaths.from.Injury.per.100k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'CDCW_TRANSPORT_DTH_RATE',	'Deaths.from.Transport.Accident.per.100k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'CDCW_SELFHARM_DTH_RATE',	'Deaths.from.Suicide.per.100k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'CDCW_ASSAULT_DTH_RATE',	'Deaths.from.Assault.per.100k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'CDCW_MATERNAL_DTH_RATE',	'Maternal.Deaths.per.100k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'CDCW_OPIOID_DTH_RATE',	'Opioid.Overdose.Deaths.per.100k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'CDCW_DRUG_DTH_RATE',	'Drug.Poisoning.Deaths.per.100k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'CHR_MENTAL_PROV_RATE',	'Mental.Health.Providers.per.100k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'NCHS_URCS_2013',	'NCHS.Rural.Urban.Code' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'HIFLD_MEDIAN_DIST_UC',	'Median.Distance.to.Urgent.Care' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'HIFLD_UC_RATE',	'Urgent.Care.Orgs.per.1k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'LTC_AVG_OBS_REHOSP_RATE',	'Average.Rehospitalization.Rate' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'LTC_AVG_OBS_SUCCESSFUL_DISC_RATE',	'Average.Successful.Discharge.Rate' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'LTC_OCCUPANCY_RATE',	'Nursing.Home.Occupancy.Rate' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'LTC_PCT_FOR_PROFIT',	'Percent.Nursing.Homes.For.Profit' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'LTC_PCT_MULTI_FAC',	'Percent.Nursing.Homes.Chain' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'MMD_ANXIETY_DISD',	'Anxiety.Disorders.Rate.Medicare' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'MMD_BIPOLAR_DISD',	'Bipolar.Disorder.Rate.Medicare' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'MMD_DEPR_DISD',	'Depressive.Disorders.Rate.Medicare' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'MMD_PERSONALITY_DISD',	'Personality.Disorders.Rate.Medicare' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'MMD_OUD_IND',	'Opioid.Overuse.Disorder.Rate.Medicare' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'PC_PCT_MEDICARE_APPRVD_FULL_AMT',	'Percent.Clinicians.Accpeting.Medicaid' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'POS_MEDIAN_DIST_ED',	'Median.Distance.to.Emergency.Department' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'POS_MEDIAN_DIST_MEDSURG_ICU',	'Median.Distance.to.Medical.Surgical.ICU' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'POS_MEDIAN_DIST_TRAUMA',	'Median.Distance.to.Trauma.Center' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'POS_MEDIAN_DIST_PED_ICU',	'Median.Distance.to.Pediatric.ICU' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'POS_MEDIAN_DIST_OBSTETRICS',	'Median.Distance.to.Obstetrics.Department' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'POS_MEDIAN_DIST_CLINIC',	'Median.Distance.to.Health.Clinic' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'POS_MEDIAN_DIST_ALC',	'Median.Distance.to.Alcohol.Drug.Incare' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'POS_FQHC_RATE',	'Health.Centers.per.1k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'POS_CMHC_RATE',	'Community.Mental.Health.Centers.per.1k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'POS_RHC_RATE',	'Rural.Health.Clinics.per.1k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'POS_HHA_RATE',	'Home.Health.Agencies.per.1k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'POS_HOSPICE_RATE',	'Hospices.per.1k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'POS_NF_RATE',	'Nursing.Facilities.per.1k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'POS_NF_BEDS_RATE',	'Nursing.Facility.Beds.per.1k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'POS_SNF_RATE',	'Skilled.Nursing.Facilities.per.1k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'POS_SNF_BEDS_RATE',	'Skilled.Nursing.Facility.Beds.per.1k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'POS_PCT_HOSP_FOR_PROFIT',	'Percent.Hospitals.Private.For.Profit' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'POS_PCT_HOSP_NON_PROFIT',	'Percent.Hospitals.Non.Profit' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'POS_PCT_HOSP_GOV',	'Percent.Hospitals.Government' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'BRFSS_OBESITY_RATE',	'Obesity.Rate' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'BRFSS_BINGE_DRINKING_RATE',	'Binge.Drinking.Rate' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'BRFSS_SMOKING_RATE',	'Smoking.Rate' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'BRFSS_DEPRESSION_RATE',	'Depression.Rate' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'BRFSS_DIABETES_RATE',	'Diabetes.Rate' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'CDC_ATSDR_SOC_VUL_OVERALL',	'Overall.Social.Vulnerability' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'CDC_ATSDR_SOC_VUL_SOCIOECONOMIC',	'Socioeconomic.Social.Vulnerability' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'CDC_ATSDR_SOC_VUL_HOUSEHOLD',	'Household.Characteristics.Social.Vulnerability' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'CDC_ATSDR_SOC_VUL_RACE_ETHNICITY',	'Race.Ethnicity.Social.Vulnerability' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'CDC_ATSDR_SOC_VUL_HOUSING_TRANSPORT',	'Housing.Transport.Social.Vulnerability' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'TDSHS_BIRTH_DEFECTS_RATE',	'Birth.Defects.per.10k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'NHTSA_TRAFF_FATALITIES_RATE',	'Traffic.Fatalities.per.100k' ))
counties_metadata = counties_metadata %>% mutate(name = str_replace(name, 'NHTSA_TRAFF_FATALITIES_BAC_08_RATE',	'Traffic.Fatalities.BAC.08.per.100k' ))





# Reorder

counties = counties %>% relocate(
  c(
    'County',
    'FIPS.Code',
    'Population' ,
    'Overall.Social.Vulnerability' ,
    'Socioeconomic.Social.Vulnerability' ,
    'Household.Characteristics.Social.Vulnerability' ,
    'Race.Ethnicity.Social.Vulnerability' ,
    'Housing.Transport.Social.Vulnerability' ,
    'Median.Age' ,
    'Percent.Age.0.to.17' ,
    'Percent.Age.Over.65' ,
    'Percent.Asian' ,
    'Percent.Black' ,
    'Percent.Hispanic' ,
    'Percent.White' ,
    'Percent.Households_Limited_English' ,
    'Percent.Veteran' ,
    'NCHS.Rural.Urban.Code' ,
    'Percent.Households.No.Computer.Device' ,
    'Percent.Households.Smarphone.Only' ,
    'Percent.Households.No.Internet' ,
    'Percent.Commute.Less.than.15min' ,
    'Percent.Commute.15min.to.29min' ,
    'Percent.Commute.30min.to.59min' ,
    'Percent.Commute.60min.or.More' ,
    'Percent.Housing.Units.No.Vehicle' ,
    'Alc.Establisments.per.100k',
    'Percent.Days.Good.Air.Quality' ,
    'Toxic.Sites.Insufficient.Data' ,
    'Toxic.Sites.Under.Control' ,
    'Toxic.Sites.Not.Under.Control' ,
    'GINI.Index' ,
    'Percent.Unemployed' ,
    'Median.Household.Income' ,
    'Median.Household.Income.Asian' ,
    'Median.Household.Income.Black' ,
    'Median.Household.Income.Hispanic' ,
    'Median.Household.Income.White' ,
    'Percent.in.Poverty' ,
    'Percent.in.Poverty.Asian' ,
    'Percent.in.Poverty.Black' ,
    'Percent.in.Poverty.Hispanic' ,
    'Percent.in.Poverty.White' ,
    'Percent.Households.Food.Stamps' ,
    'Median.Home.Value' ,
    'Median.Rent' ,
    'Percent.Less.than.Highschool' ,
    'Percent.Highschool.Graduate' ,  
    'Percent.with.Associate.Degree' ,
    'Percent.with.Bachelor.Degree' ,
    'Percent.with.Graduate.Degree' ,
    'Percent.Medicaid' ,
    'Percent.Medicare.Only' ,
    'Percent.Health.Insurance.Other' ,
    'Percent.No.Health.Insurance' ,
    'Obesity.Rate' ,
    'Diabetes.Rate' ,
    'Binge.Drinking.Rate' ,
    'Smoking.Rate' ,
    'Depression.Rate' ,
    'Anxiety.Disorders.Rate.Medicare' ,
    'Bipolar.Disorder.Rate.Medicare' ,
    'Depressive.Disorders.Rate.Medicare' ,
    'Personality.Disorders.Rate.Medicare' ,
    'Opioid.Overuse.Disorder.Rate.Medicare' ,
    'Birth.Defects.per.10k' ,
    'Deaths.from.Injury.per.100k' ,
    'Deaths.from.Transport.Accident.per.100k' ,
    'Deaths.from.Suicide.per.100k' ,
    'Deaths.from.Assault.per.100k' ,
    'Maternal.Deaths.per.100k' ,
    'Opioid.Overdose.Deaths.per.100k' ,
    'Drug.Poisoning.Deaths.per.100k' ,
    'Traffic.Fatalities.per.100k' ,
    'Traffic.Fatalities.BAC.08.per.100k' ,
    'Opioid.Dispensing.Rate.per.100',
    'PCPs.per.100k',
    'LCDCs.per.100k',
    'LPCs.per.100k',
    'LCSWs.per.100k',
    'LBSWs.per.100k',
    'LMSWs.per.100k',
    'Dentists.per.1k' ,
    'Nurse.Practitioners.per.1k' ,
    'Physician.Assistants.per.1k' ,
    'Mental.Health.Providers.per.100k' ,
    'Percent.Clinicians.Accpeting.Medicaid' ,
    'Dentist.Shortage.Code' ,
    'Mental.Healthcare.Shortage.Code' ,
    'Primary.Care.Shortage.Code' ,
    'Urgent.Care.Orgs.per.1k' ,
    'Health.Centers.per.1k' ,
    'Community.Mental.Health.Centers.per.1k' ,
    'Rural.Health.Clinics.per.1k' ,
    'Home.Health.Agencies.per.1k' ,
    'Hospices.per.1k' ,
    'Nursing.Facilities.per.1k' ,
    'Nursing.Facility.Beds.per.1k' ,
    'Skilled.Nursing.Facilities.per.1k' ,
    'Skilled.Nursing.Facility.Beds.per.1k' ,
    'Nursing.Home.Occupancy.Rate',
    'Percent.Nursing.Homes.For.Profit',
    'Percent.Nursing.Homes.Chain',
    'Average.Rehospitalization.Rate' ,
    'Average.Successful.Discharge.Rate' ,
    'Percent.Hospitals.Private.For.Profit' ,
    'Percent.Hospitals.Non.Profit' ,
    'Percent.Hospitals.Government',
    'Syringe.Exchange.Programs.per.1k' ,
    'Substance.Abuse.Facilities.per.1k' ,
    'Substance.Abuse.Facilities.Accepting.Medicare.per.1k' ,
    'Mental.Health.Facilities.per.1k' ,
    'Mental.Health.Facilities.Accepting.Medicare.per.1k' ,
    'Median.Distance.to.Urgent.Care' ,
    'Median.Distance.to.Emergency.Department' ,
    'Median.Distance.to.Medical.Surgical.ICU' ,
    'Median.Distance.to.Trauma.Center' ,
    'Median.Distance.to.Pediatric.ICU' ,
    'Median.Distance.to.Obstetrics.Department' ,
    'Median.Distance.to.Health.Clinic' ,
    'Median.Distance.to.Alcohol.Drug.Incare' 
  )
)

# Make sure all variables are in metadata and not duplicated
tmp_cols_in_metadata = !colnames(counties) %in% counties_metadata$name
length(tmp_cols_in_metadata[tmp_cols_in_metadata == TRUE]) # should give 0

tmp_metadata_in_cols = !counties_metadata$name %in% colnames(counties)
length(tmp_metadata_in_cols[tmp_metadata_in_cols == TRUE]) # should give 0

counties_metadata[duplicated(counties_metadata$name),]$name


# Delete vars
rm(list = ls(, pattern = "category_"))
rm(list = ls(, pattern = "tmp"))















######################################
# EXPORT
#
# 
#
#######################################

counties_metadata = counties_metadata %>% arrange(
  category
)

write.csv(counties_metadata, file="output/data/tchn_metadata_latest.csv", row.names = FALSE)
write.csv(counties, file="output/data/tchn_latest.csv", row.names = FALSE)


# Read the file back in to flatten, convert to character, replace NAs and save again.
counties = read_csv('output/data/tchn_latest.csv')

counties = counties %>%
  mutate(across(everything(), as.character))

counties[is.na(counties)] = ""

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




















# ######################################           Unfinished -- replace with sdoh?
# # HEALTHCARE PROVIDERS
# #
# # Gets downloaded manually every year from:
# # https://data.hrsa.gov/topics/health-workforce/ahrf
# #
# # Select category and Texas. Actual years are listed in source column.
# #
# #######################################
# 
# hrsa_md_2020 = read.csv('raw_data/hrsa/hrsa_md_2020.csv')
# 
# 







# ######################################        UNFINISHED
# # NEW HIV CASE DATA -
# #
# # Gets downloaded manually every year from:
# # https://healthdata.dshs.texas.gov/dashboard/diseases/new-hiv-diagnoses-summary
# #
# # Download crosstab for all cases with all selected for each option
# # Per email: Rate represents cases per 100,000 population in each jurisdiction.
# #
# #######################################
# 
# tdshs_hiv_cases_new = read.csv('raw_data/tdshs/tdshs_hiv_cases_new.csv')
# 
# # Remove Texas
# tdshs_hiv_cases_new = tdshs_hiv_cases_new %>% filter(
#   Area != "Texas"
# )
# 
# tdshs_hiv_cases_new = tdshs_hiv_cases_new %>% rename (
#   "County" = "Area",
#   "2010" = "X2010",
#   "2011" = "X2011",
#   "2012" = "X2012",
#   "2013" = "X2013",
#   "2014" = "X2014",
#   "2015" = "X2015",
#   "2016" = "X2016",
#   "2017" = "X2017",
#   "2018" = "X2018",
#   "2019" = "X2019"
# )
# 
# # Filter for only all cases - remove demographics
# tdshs_hiv_cases_new_all = tdshs_hiv_cases_new %>% filter(
#   Age.group == "All",
#   Race == "All",
#   Sex == "All",
#   X == "Rate"
# )
# 
# tdshs_hiv_cases_new_all = tdshs_hiv_cases_new_all %>% select(-c(
#   Age.group,
#   Race,
#   Sex,
#   X
# ))
# 
# # Filter for Black
# tdshs_hiv_cases_new_black = tdshs_hiv_cases_new %>% filter(
#   Age.group == "All",
#   Race == "Black",
#   Sex == "All",
#   X == "Rate"
# )
# 
# tdshs_hiv_cases_new_black = tdshs_hiv_cases_new_black %>% select(-c(
#   Age.group,
#   Race,
#   Sex,
#   X
# ))
# 






# 
# 
# ######################################.    Not sure what to do with this ... is it national somewhere? I'm worried about the race categories causing suppression.

# # INFANT MORTALITY DATA
# #
# # Gets downloaded manually every year from:
# # https://healthdata.dshs.texas.gov/dashboard/births-and-deaths/infant-deaths
# #
# # Custom data table - race/ethnicity, select year
# #
# #######################################
# 
# # Read
# tdshs_infant_deaths_2019 = read.csv('raw_data/tdshs/tdshs_infant_deaths_2019.csv')
# tdshs_infant_deaths_2018 = read.csv('raw_data/tdshs/tdshs_infant_deaths_2018.csv')
# tdshs_infant_deaths_2017 = read.csv('raw_data/tdshs/tdshs_infant_deaths_2017.csv')
# tdshs_infant_deaths_2016 = read.csv('raw_data/tdshs/tdshs_infant_deaths_2016.csv')
# tdshs_infant_deaths_2015 = read.csv('raw_data/tdshs/tdshs_infant_deaths_2015.csv')
# 
# # Add year col
# tdshs_infant_deaths_2019$Year = 2019
# tdshs_infant_deaths_2018$Year = 2018
# tdshs_infant_deaths_2017$Year = 2017
# tdshs_infant_deaths_2016$Year = 2016
# tdshs_infant_deaths_2015$Year = 2015
# 
# # Merge
# tdshs_infant_deaths = rbind(
#   tdshs_infant_deaths_2019,
#   tdshs_infant_deaths_2018,
#   tdshs_infant_deaths_2017,
#   tdshs_infant_deaths_2016,
#   tdshs_infant_deaths_2015
# )
# 
# # Rename
# tdshs_infant_deaths = tdshs_infant_deaths %>% rename (
#   County = X,
#   Black = Non.Hispanic.Black,
#   Other = Non.Hispanic.Other,
#   White = Non.Hispanic.White
# )
# 
# # Fix columns
# tdshs_infant_deaths$Hispanic = as.numeric(tdshs_infant_deaths$Hispanic)
# tdshs_infant_deaths$Black = as.numeric(tdshs_infant_deaths$Black)
# tdshs_infant_deaths$White = as.numeric(tdshs_infant_deaths$White)
# tdshs_infant_deaths$Other = as.numeric(tdshs_infant_deaths$Other)
# 
# # Reduce to latest year and merge
# tdshs_infant_deaths_latest =  tdshs_infant_deaths %>% 
#   filter(Year == max(Year))
# 
# tdshs_infant_deaths_latest = select(tdshs_infant_deaths_latest, -c('Year'))
# 
# tdshs_infant_deaths_latest = tdshs_infant_deaths_latest %>% rename (
#   Infant_Deaths_Hispanic = Hispanic,
#   Infant_Deaths_Black = Black,
#   Infant_Deaths_White = White,
#   Infant_Deaths_Other = Other
# )
# 
# tdshs_infant_deaths_latest = tdshs_infant_deaths_latest %>% relocate(
#   Infant_Deaths_Black,
#   Infant_Deaths_Hispanic,
#   Infant_Deaths_Other,
#   Infant_Deaths_White
# )
# 
# tmp_by = join_by('Name' == 'County')
# counties = left_join(counties, tdshs_infant_deaths_latest, tmp_by )
# 
# # Make long
# tdshs_infant_deaths_long = tdshs_infant_deaths %>% pivot_longer(
#   -c(County, Year),
#   names_to = "Race",
#   values_to = "Infant_Deaths"
# )
# 
# # Make wide
# tdshs_infant_deaths_longitudinal = tdshs_infant_deaths_long %>% pivot_wider(
#   names_from = c(Year),
#   values_from = Infant_Deaths
# )
# 
# write.csv(
#   tdshs_infant_deaths_longitudinal, 
#   file = 'output/data/tdshs_infant_deaths_longitudinal.csv', 
#   row.names = FALSE
# )
# 
# write.csv(
#   tdshs_infant_deaths_long, 
#   file = 'output/data/tdshs_infant_deaths_long.csv', 
#   row.names = FALSE
# )
# 
# # Clean up
# rm(list = ls(, pattern = "tdshs_infant_deaths"))








######################################.   This is in SDOH, but we can use the below if we want longitudinal

# PROCESS AND MERGE SUICIDE DATA
#
# Gets downloaded manually every year from:
# https://healthdata.dshs.texas.gov/dashboard/births-and-deaths/deaths
#
# Cause of death: intentional self-harm (both)
#
#######################################

# # Read
# tmp_by = join_by('X' == 'County')
# 
# tdshs_suicide_2015 = read.csv('raw_data/tdshs/tdshs_suicide_2015.csv')
# #tdshs_suicide_2015 = left_join(tdshs_suicide_2015, county_populations[`2015`], tmp_by )
# 
# tdshs_suicide_2016 = read.csv('raw_data/tdshs/tdshs_suicide_2016.csv')
# tdshs_suicide_2017 = read.csv('raw_data/tdshs/tdshs_suicide_2017.csv')
# tdshs_suicide_2018 = read.csv('raw_data/tdshs/tdshs_suicide_2018.csv')
# tdshs_suicide_2019 = read.csv('raw_data/tdshs/tdshs_suicide_2019.csv')
# tdshs_suicide_2020 = read.csv('raw_data/tdshs/tdshs_suicide_2020.csv')
# 
# tdshs_suicide_2015$Year = 2015
# tdshs_suicide_2016$Year = 2016
# tdshs_suicide_2017$Year = 2017
# tdshs_suicide_2018$Year = 2018
# tdshs_suicide_2019$Year = 2019
# tdshs_suicide_2020$Year = 2020
# 
# 
# # Merge
# tdshs_suicide = rbind(
#   tdshs_suicide_2015,
#   tdshs_suicide_2016,
#   tdshs_suicide_2017,
#   tdshs_suicide_2018,
#   tdshs_suicide_2019,
#   tdshs_suicide_2020
#   )
# 
# # Reduce
# tdshs_suicide = select(tdshs_suicide, c(X,All.Deaths,Year))
# tdshs_suicide = tdshs_suicide %>% rename(
#   County = X,
#   TDSHS_DEATHS_SUICIDE = All.Deaths
# )
# 
# # Fix columns
# tdshs_suicide$TDSHS_DEATHS_SUICIDE = as.numeric(tdshs_suicide$TDSHS_DEATHS_SUICIDE)
# 
# # Reduce to latest year and merge
# tdshs_suicide_latest =  tdshs_suicide %>% 
#   filter(Year == max(Year))
# 
# tdshs_suicide_latest = select(tdshs_suicide_latest, -c('Year'))
# 
# tmp_by = join_by('Name' == 'County')
# counties = left_join(counties, tdshs_suicide_latest, tmp_by )
# 
# # Make logitudinal and save
# tdshs_suicide_longitudinal = pivot_wider(
#   tdshs_suicide,
#   names_from = Year,
#   values_from = Deaths_Suicide
# )
# 
# tdshs_suicide_longitudinal = tdshs_suicide_longitudinal %>% arrange(
#   County
# )
# 
# write.csv(
#   tdshs_suicide_longitudinal, 
#   file = 'output/data/tdshs_suicide_longitudinal.csv', 
#   row.names = FALSE
# )
# 
# write.csv(
#   tdshs_suicide, 
#   file = 'output/data/tdshs_suicide_long.csv', 
#   row.names = FALSE
# )
# 
# # Clean up
# rm(list = ls(, pattern = "tdshs_suicide"))




