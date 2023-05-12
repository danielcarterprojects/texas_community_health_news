setwd("~/Documents/Academics/TCHN")

library('tidyverse')
library('stringr')

# Outputs:
#           .md files that generate the HTML for individual visualizations
#           visualization_types.csv file that is used to generate the list of visualizations

jekyll_visualization_directory = "~/tchn/_visualizations/"
jekyll_data_directory = "~/tchn/_data/"

counties = read_csv('raw_data/counties.csv')
visualizations = read_csv('scripts/visualization_types.csv')

visualizations_out = data.frame()

for (i in 1:nrow(visualizations)) {
  for (j in 1:nrow(counties)) {
    
    tmp_slug = str_c(
      visualizations[i,'slug'],
      '-', 
      counties[j,'fips'],
      collapse=""
    )
    
    tmp_include = str_replace(
      visualizations[i,'include'],
      'XXX',
      as.character(counties[j,]$fips)
    )
    
    tmp_row = c(tmp_slug, tmp_include)
    
    visualizations_out = rbind(visualizations_out, tmp_row)
    
    fileConn = file(
      str_c(
        jekyll_visualization_directory,
        tmp_slug,
        ".md",
        collapse = ""
      )
    )
    writeLines(
      c(
        "---",
        "layout: visualizations",
        "---",
        tmp_include
        ), 
      fileConn)
    close(fileConn)
  }
}

write.csv(
  visualizations, 
  file=str_c(jekyll_data_directory,"visualization_types.csv",collapse=""),
  row.names = FALSE
)