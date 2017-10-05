url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
download.file(url, destfile='Idaho.csv')
ds <- read.csv('Idaho.csv')

url2 <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv'
download.file(url2, destfile='Gross.csv')
gross <- read.csv('Gross.csv', skip=4, header=T)

gross$gdp <- gsub(',','',gross$X.4)
gross <- gross[gross$X.1!='',]
head(gross)    

mean(as.numeric(gross$gdp), na.rm=T)


url3 <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv'
download.file(url3, destfile='Educ.csv')
educ <- read.csv('Educ.csv', header=T)

mds <- merge(educ, gross, by.y='X', by.x='CountryCode')

grep('Fiscal year end: June', educ$Special.Notes)
