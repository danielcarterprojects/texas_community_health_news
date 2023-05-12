setwd("~/Documents/Academics/TCHN")

library('tidyverse')
library('stringr')

counties = read.csv('raw_data/counties.csv')
counties$State = "Texas"

county_populations = read_csv('raw_data/county_populations_historical.csv')

county_economic_regions = read_csv('raw_data/county_economic_regions.csv')

suicides_long = read_csv('output/data/tdshs_suicide_long.csv')

suicides_long = suicides_long %>% select(c('County','Year','TDSHS_DEATHS_SUICIDE'))

suicides_long = left_join(suicides_long, county_economic_regions, by=join_by('County' == 'County'))

suicides_long = suicides_long %>% filter(
  !is.na(TDSHS_DEATHS_SUICIDE)
)

suicides_long$Population = 0

for (i in 1:nrow(suicides_long)) {
  
  tmp_year_col = str_c("X.",suicides_long[i,]$Year, collapse="")
  tmp_county = suicides_long[i,]$County
  
  tmp_population = county_populations %>% filter(
    County == `tmp_county`
  ) %>% select(
    all_of(`tmp_year_col`)
  )
  
  suicides_long[i,]$Population = tmp_population[[1,1]]
  
}

suicides_region = suicides_long %>% group_by(Economic.Region, Year) %>% summarise(
  Population = sum(Population),
  Deaths_Suicide = sum(TDSHS_DEATHS_SUICIDE)
)

suicides_region$Suicide_Rate = suicides_region$Deaths_Suicide/suicides_region$Population * 100000

write.csv(suicides_region, file="output/projects/suicide/suicide_rate_x_region.csv", row.names = FALSE)




#####################
# Repeat for firearms


suicides_firearms_long = read_csv('output/data/tdshs_suicide_firearms_long.csv')

suicides_firearms_long = suicides_firearms_long %>% select(c('County','Year','TDSHS_DEATHS_SUICIDE'))

suicides_firearms_long = left_join(suicides_firearms_long, county_economic_regions, by=join_by('County' == 'County'))

suicides_firearms_long = suicides_firearms_long %>% filter(
  !is.na(TDSHS_DEATHS_SUICIDE)
)

suicides_firearms_long$Population = 0

for (i in 1:nrow(suicides_firearms_long)) {
  
  tmp_year_col = str_c("X.",suicides_firearms_long[i,]$Year, collapse="")
  tmp_county = suicides_firearms_long[i,]$County
  
  tmp_population = county_populations %>% filter(
    County == `tmp_county`
  ) %>% select(
    all_of(`tmp_year_col`)
  )
  
  suicides_firearms_long[i,]$Population = tmp_population[[1,1]]
  
}

suicides_firearms_region = suicides_firearms_long %>% group_by(Economic.Region, Year) %>% summarise(
  Population = sum(Population),
  Deaths_Suicide = sum(TDSHS_DEATHS_SUICIDE)
)

suicides_firearms_region$Suicide_Rate = suicides_firearms_region$Deaths_Suicide/suicides_firearms_region$Population * 100000

write.csv(suicides_firearms_region, file="output/projects/suicide/suicide_firearms_rate_x_region.csv", row.names = FALSE)
