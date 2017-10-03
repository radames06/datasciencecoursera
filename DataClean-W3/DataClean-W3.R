url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
download.file(url, destfile='Idaho.csv')
ds <- read.csv('Idaho.csv')

agri <- ds[ds$ACR==3 & ds$AGS==6,]
agriLogic <- (ds$ACR==3 & ds$AGS==6)

#question 3
library(dplyr)

url2 <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv'
url3 <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv'

download.file(url2, destfile='gross.csv')
download.file(url3, destfile='educ.csv')
gross <- read.csv('gross.csv',skip=4)
educ <- read.csv('educ.csv')

gross_summary <- gross[(gross$X!=''),c('X','X.1')]
colnames(gross_summary) <- c('Country_code','ranking')
gross_summary$ranking[gross_summary$ranking==''] <- 'NA'
gross_summary$ranking <- as.numeric(as.character(gross_summary$ranking))
educ_summary <- educ[,c('CountryCode', 'Short.Name')]
colnames(educ_summary) <- c('Country_code','Country_name')

merged_ds <- merge(gross_summary, educ_summary, by = 'Country_code')
#revrs$Gross.domestic.product.2012 <- as.numeric(revrs$Gross.domestic.product.2012)
merged_ds <- merged_ds[order(merged_ds$ranking, decreasing = T),]


y <- z[!is.na(z$ranknum),]
sapply(split(y$ranknum, y$Income.Group), mean)
#question 5
z<- cut(y$ranknum,quantile(y$ranknum,probs=seq(0,1,0.20)))
