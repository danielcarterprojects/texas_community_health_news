setwd("~/Documents/Academics/News Deserts")

library('dplyr')
library('stringr')

# Read in data.
thrc_data = read.csv('raw_data/thrc_data_v1_3.csv') # THRC Data
traffic_fatalities = read.csv('raw_data/Traffic_Fatalities_2020.csv')

# Remove unwanted columns from THRC data.
remove_from_thrc = c(
  "alc_est_per_capita",
  "Temp_MH_Services_NewApp_2020",                          
  "Ext_MH_Services_NewApp_2020",                           
  "Modification_NewApp_2020",                              
  "Auth_Meds_NewApp_2020",                                 
  "Temp_MH_Services_Hearing_2020",                         
  "Ext_MH_Services_Hearing_2020",                          
  "Modification_Hearing_2020",                             
  "Auth_Meds_Hearing_2020",                                
  "Temp_MH_Services_NewApp_2020_per100k",                  
  "Ext_MH_Services_NewApp_2020_per100k",                   
  "Modification_NewApp_2020_per100k",                      
  "Auth_Meds_NewApp_2020_per100k",                         
  "Temp_MH_Services_Hearing_2020_per100k",                 
  "Ext_MH_Services_Hearing_2020_per100k",                  
  "Modification_Hearing_2020_per100k",                     
  "Auth_Meds_Hearing_2020_per100k",
  "MSA_type",                                              
  "Central_Outlying",                                      
  "CBSA.Code",                                             
  "CBSA.Title",                                            
  "CBSA.level",                                            
  "RUCC_2013",                                             
  "UIC_2013",
  "percent_comp",
  "Total.Traffic.Fatalities",                              
  "Total.Traffic.Fatalities.BAC.gt.08",                    
  "Percent.Traffic.Fatalities.BAC.gt.08",                  
  "Traffic_Fatalities_per_100k"
)

data = thrc_data[ , -which(names(thrc_data) %in% remove_from_thrc)]

# Merge in traffic fatalities

data = merge(data, traffic_fatalities, by.x = 'Name', by.y = 'County', all.x = TRUE)

# Rename columns

data = data %>% rename(
  "County" = "Name",
  "FIPS_Code" = "fips",
  "Poverty_Percent_All" = "pov_perc_all",
  "Poverty_Percent_Under_18" = "pov_perc_under_18",
  "Total_Population_2018" = "total_pop",
  "Jail_Population_Total" = "total_jail_pop",
  "Jail_Population_Pretrial" = "total_jail_pretrial",
  "Unemployment_Rate" = "unemployment",
  "Total_Population_2020" = "X2020.Total.Population",
  "LCDC_Total" = "X2020.LCDC.Total",
  "LCDCs_per_100k" = "Ratio.of.LCDCs.to.100.000.Population",
  "LCSW_Total" = "X2020.LCSW.Total",
  "LCSWs_per_100k" = "Ratio.of.LCSWs.to.100.000.Population",
  "LPC_Total" = "X2020.LPC.Total",
  "LPCs_per_100k" = "Ratio.of.LPCs.to.100.000.Population",
  "LBSW_Total" = "X2020.LBSW.Total",
  "LBSWs_per_100k" = "Ratio.of.LBSWs.to.100.000.Population",
  "LMSW_Total" = "X2020.LMSW.Total",
  "LMSWs_per_100k" = "Ratio.of.LMSWs.to.100.000.Population",
  "PCP_Total" = "X2020.Primary.Care.Physician.Total",
  "PCPs_per_100k" = "Ratio.of.Primary.Care.Physicians.to.100.000.Population",
  "NCHS_Score" = "NCHS_2013",
  "Opioid_Prescriptions_per_100" = "opioid_per_100",
  "Veteran_Percentage" = "vet_percent_2020",
  "Uninsured_Percentage" = "percent_uninsured",
  "Psychiatrists_Total" = "X2020.Psychiatrist.Total",
  "Psychiatrists_per_100k" = "Ratio.of.Psychiatrists.to.100.000.Population",
  "I35_Corridor" = "I_35",
  "Total_Traffic_Fatalities_BAC_.08" = "Total_Traffic_Fatalities_BAC_.08._2020",
  "Total_Traffic_Fatalities" = "Total_Traffic_Fatalities_2020"
)

# Reorder columns

data = data %>% relocate(State, .after = County)
data = data %>% relocate(State, .after = County)
data = data %>% relocate(Total_Population_2018, .after = FIPS_Code)
data = data %>% relocate(Total_Population_2020, .after = Total_Population_2018)
data = data %>% relocate(Unemployment_Rate, .after = Total_Population_2020)
data = data %>% relocate(NCHS_Score, .after = FIPS_Code)
data = data %>% relocate(Uninsured_Percentage, .after = Unemployment_Rate)
data = data %>% relocate(Opioid_Prescriptions_per_100, .after = Schizophrenia_Other_Psychotic_Disorders)
data = data %>% relocate(Psychiatrists_Total, .after = PCPs_per_100k)
data = data %>% relocate(Psychiatrists_per_100k, .after = Psychiatrists_Total)
data = data %>% relocate(Veteran_Percentage, .after = Poverty_Percent_Under_18)
data = data %>% relocate(Total_Traffic_Fatalities_BAC_.08, .after = Total_Traffic_Fatalities)
data = data %>% relocate(Jail_Population_Total, .after = Total_Traffic_Fatalities_BAC_.08)
data = data %>% relocate(Jail_Population_Pretrial, .after = Jail_Population_Total)


# Clean up
rm(thrc_data)
rm(traffic_fatalities)

# Merge ACS data

acs_data = read.csv('raw_data/acs_data_latest.csv')

acs_data$County.Code = as.character(acs_data$County.Code)
acs_data$County.Code = str_pad(acs_data$County.Code, 3, pad="0")
acs_data$County.Code = paste(
  "48",
  acs_data$County.Code,
  sep=""
)
acs_data$County.Code = as.integer(acs_data$County.Code)

data = merge(data, acs_data, by.x = 'FIPS_Code', by.y = 'County.Code', all.x = TRUE)

rm(acs_data)

# Rename columns and reorder.

data = data %>% rename(
  "Hispanic_Percent" = "ACS5Y2020_Hispanic_Percent",
  "Education_Highschool_Percent" = "ACS5Y2020_Highschool_Percent",
  "Education_GED_Percent" = "ACS5Y2020_GED_Percent",
  "Education_Bachelors_Percent" = "ACS5Y2020_Bachelors_Percent",
  "Education_Masters_Percent" = "ACS5Y2020_Masters_Percent",
  "Education_Professional_Percent" = "ACS5Y2020_Professional_Percent",
  "Education_Doctorate_Percent" = "ACS5Y2020_Doctorate_Percent",
  "SNAP_Percent" = "ACS5Y2020_SNAP_Percent",
  "Median_Household_Income" = "ACS5Y2020_Median.Household.Income",
  "GINI_Index" = "ACS5Y2020_GINI_Index"
)

data = select(data, -c('X',"ACS5Y2020_Unemployment_Percent",'ACS5Y2020_Poverty_Percent'))

data = data %>% relocate(Median_Household_Income, .after = Total_Population_2020)
data = data %>% relocate(GINI_Index, .after = Median_Household_Income)
data = data %>% relocate(Hispanic_Percent, .after = Total_Population_2020)
data = data %>% relocate(SNAP_Percent, .after = Uninsured_Percentage)
data = data %>% relocate(Education_GED_Percent, .after = Veteran_Percentage)
data = data %>% relocate(Education_Highschool_Percent, .after = Education_GED_Percent)
data = data %>% relocate(Education_Bachelors_Percent, .after = Education_Highschool_Percent)
data = data %>% relocate(Education_Masters_Percent, .after = Education_Bachelors_Percent)
data = data %>% relocate(Education_Professional_Percent, .after = Education_Masters_Percent)
data = data %>% relocate(Education_Doctorate_Percent, .after = Education_Professional_Percent)


# Correct value errors
data$LCSW_Total = gsub(",","",data$LCSW_Total)
data$LCSW_Total = as.numeric(data$LCSW_Total)

data$LPC_Total = gsub(",","",data$LPC_Total)
data$LPC_Total = as.numeric(data$LPC_Total)

data$LMSW_Total = gsub(",","",data$LMSW_Total)
data$LMSW_Total = as.numeric(data$LMSW_Total)

data$PCP_Total = gsub(",","",data$PCP_Total)
data$PCP_Total = as.numeric(data$PCP_Total)

data[is.na(data)] = ""


# Export

write.csv(data, file="output/data/tchn_latest.csv", row.names = FALSE)
write.csv(
  data, 
  file=paste(
    "output/data/tchn_", 
    format(Sys.time(), "%Y%m%d"), 
    ".csv",
    collapse = "",
    sep=""), row.names = FALSE 
)


