
pollutantmean <- function(directory, pollutant, id=1:332) {
    list_names <- sprintf('/%03d.csv',id)
    ds <- NULL
    for (i in list_names) {
        ds <- rbind(ds,read.csv(paste(directory,i,sep='')))
    }
    
    mean(ds[,pollutant],na.rm=TRUE)
}

complete <- function(directory, id=1:332) {
    result <- NULL
    for (i in id) {
        current_file <- read.csv(paste(directory,sprintf('/%03d.csv',i),sep=''))
        result <- c(result,sum(complete.cases(current_file$nitrate,current_file$sulfate)))
    }
    
    data.frame(id,nobs=result)
}


corr <- function(directory, threshold = 0) {
    list_names <- list.files(directory)
    list_id <- as.numeric(substr(list_names,0,3))
    result <- as.numeric(NULL)
    compl <- complete(directory)
    
    for (i in list_id) {
        if (compl[compl$id==i,2]>threshold) {
            current_file <- read.csv(paste(directory,sprintf('/%03d.csv',i),sep=''))
            result <- c(result,cor(current_file$sulfate,current_file$nitrate,use="complete.obs"))
        }
    }
    result
}



