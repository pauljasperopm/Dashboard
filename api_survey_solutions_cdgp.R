library(shiny)
library(datasets)
library(dplyr)
library(ggplot2)
library(rsconnect)
library(shinydashboard)
library(sjlabelled)
library(httr)
library(haven)



hq_address <- "https://cdgp.mysurvey.solutions"
ex_type <- "stata"
qqn_id <- "5de20d1c-baae-4f18-abf3-577207488513$10"
action <- "start"

query <- sprintf("%s/api/v1/export/%s/%s/%s", hq_address, ex_type, qqn_id, action)
query 

data <- POST(query, authenticate("PJasper", "Tent2lip!23"))
str(data)

action <- ""
query <- sprintf("%s/api/v1/export/%s/%s/%s", hq_address, ex_type, qqn_id, action)

data <- GET(query, authenticate("PJasper", "Tent2lip!23"))

str(data)

##Download was succesful

#create temporary directory for storing and unzipping file
td <- "C:/Users/pjasper/Dropbox (OPML)/LIGADA MEL/Data Analysis/xx_dashboard_development"

#open connection to write contents
filecon <- file(file.path(td, "CDGP.zip"),"wb") 

#write data contents to the temporary file
writeBin(data$content, filecon) 
#close the connection
close(filecon)


#unzip zip file 
zipF <- paste0(td, "//CDGP.zip")

##only unzil CDGP_EL_HH
unzip(zipF, files="CDGP_EL_HH.dta", exdir = td)


cdgp_hh <- read_dta("C:/Users/pjasper/Dropbox (OPML)/LIGADA MEL/Data Analysis/xx_dashboard_development/CDGP_EL_HH.dta")

##produce a simple graph that shows sample size by lga

# Create the summary statistics 

cdgp_hh$lga_f <-as_label(cdgp_hh$lga_id)

sumbylga<- cdgp_hh %>%
  group_by(lga_f) %>%
  summarise(n=n())

# Plot by lga
ggplot(sumbylga, aes(x =lga_f, y = n)) + geom_bar(stat = 'identity', position = 'dodge') + 
  ylab("Total entries") + xlab("LGA") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))





##Reading tab into R doesn't seem to be working for some reason
##The below code is therefore redundant. 
##read into R
##there is an issue here with the number of variables and entries - in Stat this is slightly different
##I am not addressing this here right now. 
##cdgp_hh <- read.table("C:/Users/pjasper/Dropbox (OPML)/LIGADA MEL/Data Analysis/xx_dashboard_development/CDGP_EL_HH.tab", header=TRUE, fill=TRUE)




##The below is copied from 
##https://rstudio-pubs-static.s3.amazonaws.com/239851_1bc298ae651c41c7a65e09ce82f9053f.html
#read in data files and store as elements in a list
##data.files <- list.files(td, pattern = ".tab")

##data.files <- paste0(td, "/", data.files)

##x <- vector("list", length(data.files))
#names(x) <- data.files

#x <- lapply(data.files, function(x) read.delim(x))

#show objects in list
#sapply(x, class)


