setwd("~/Documents/Academics/News Deserts/data/scripts")

library(tidyverse)
library(readxl)

papers = read_excel("../2022TPADirectory_Jan2022.xlsx")
papers$County = trimws(papers$County)
thrc_data = read_csv("../thrc_data_merged_latest.csv")

papers = left_join(papers, thrc_data, by = c('County' = 'Name'))

write.csv(papers, file=paste("../", "tpa_thrc_merged_", format(Sys.Date(), format="%Y%m%d"), ".csv", sep="", collapse=""), row.names = FALSE)
write.csv(papers, file=paste("../", "tpa_thrc_merged_latest.csv", sep="", collapse=""), row.names = FALSE)


