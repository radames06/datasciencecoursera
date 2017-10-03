#question 1
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
ds <- download.file(url, destfile="house.csv")

ds <- read.table("house.csv",sep=',', header=T)

sum(ds$VAL==24,na.rm = T)


#question 3

library(xlsx)
url2 <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx'
ds <- download.file(url2, destfile="gas.xlsx", mode='wb')

ds <- read.xlsx("gas.xlsx",sheetIndex = 1, header=TRUE, startRow = 18, endRow = 23
                ,colIndex=c(7:15))

sum(ds$Zip*ds$Ext,na.rm=T)


#question 4 
library(XML)
url3 <- 'http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml'
ds3 <- xmlTreeParse(url3, useInternal = TRUE)
rootnode <- xmlRoot(ds3)
restos <- xpathSApply(rootnode, "//zipcode", xmlValue)
sum(restos==21231)

#question 5
library(data.table)
url4 <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv'
download.file(url4, destfile='idaho.csv')
DT <- fread('idaho.csv', header=T)

start.time <- Sys.time()
mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)
end.time <- Sys.time()
end.time-start.time

DT[,mean(pwgtp15),by=SEX] #0.00500083 secs
sapply(split(DT$pwgtp15,DT$SEX),mean) #0.003000021
mean(DT$pwgtp15,by=DT$SEX) #0.003000021 secs
tapply(DT$pwgtp15,DT$SEX,mean) #0.003000021 secs
mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15) #0.229013 secs