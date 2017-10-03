best <- function(state, outcome) {
    ## Read outcome data
    ds <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
    
    ## Check that state and outcome are valid
    if (sum(ds$State==state)==0) {
        cat('Error in best(\"',state,'\", \"', outcome,'\") : invalid state',sep='')
    }
    else if (outcome != 'heart attack' & outcome != 'heart failure' & outcome != 'pneumonia') {
        cat('Error in best(\"',state,'\", \"', outcome,'\") : invalid outcome',sep='')
    }
    ## Return hospital name in that state with lowest 30-day death
    ## rate
    else {
        col_outcome = switch(outcome,
                             'heart attack' = {11},
                             'heart failure' = {17},
                             'pneumonia' = {23})

        tdata <- ds[ds[,7]==state,c(2,7,col_outcome)]
        options(warn=-1)
        tdata[,3] <- as.numeric(as.character(tdata[,3]))
        options(warn=0)
        
        tdata <- tdata[order(tdata[,1],decreasing=F),]
        tdata[which.min(c(tdata[,3])),1]
    }
}

# Tests
best("TX", "heart attack") #CYPRESS FAIRBANKS MEDICAL CENTER
best("TX", "heart failure") #"FORT DUNCAN MEDICAL CENTER
best("MD", "heart attack") #JOHNS HOPKINS HOSPITAL, THE
best("MD", "pneumonia") #GREATER BALTIMORE MEDICAL CENTER
best("BB", "heart attack") #error
best("NY", "hert attack") #error




rankhospital <- function(state, outcome, num = "best") {
    ## Read outcome data
    ds <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
    ## Check that state and outcome are valid
    if (sum(ds$State==state)==0) {
        cat('Error in best(\"',state,'\", \"', outcome,'\") : invalid state',sep='')
    }
    else if (outcome != 'heart attack' & outcome != 'heart failure' & outcome != 'pneumonia') {
        cat('Error in best(\"',state,'\", \"', outcome,'\") : invalid outcome',sep='')
    }
    ## Return hospital name in that state with the given rank
    ## 30-day death rate
    else {
        col_rate = switch(outcome,
                             'heart attack' = {11},
                             'heart failure' = {17},
                             'pneumonia' = {23})
        tdata <- ds[ds[,7]==state, c(2,col_rate)]
        options(warn=-1)
        tdata[,2] <- as.numeric(as.character(tdata[,2]))
        options(warn=0)
        
        tdata <- tdata[order(tdata[2], tdata[,1]),]
        
        if (num=="best") {num <- 1}
        if (num=="worst") {num <- dim(tdata)[1]-sum(is.na(tdata[,2]))}
        tdata[num,1]
    }    
}

#Tests
rankhospital("TX", "heart failure", 4) #DETAR HOSPITAL NAVARRO
rankhospital("MD", "heart attack", "worst") #HARFORD MEMORIAL HOSPITAL
rankhospital("MN", "heart attack", 5000) #


rankall <- function(outcome, num = "best") {
    ## Read outcome data
    ds <- read.csv("outcome-of-care-measures.csv")
    col_rank = switch(outcome,
                      'heart attack' = {11},
                      'heart failure' = {17},
                      'pneumonia' = {23})
    ## Check that state and outcome are valid
    if (sum(ds$State==state)==0) {
        cat('Error in best(\"',state,'\", \"', outcome,'\") : invalid state',sep='')
    }
    else if (outcome != 'heart attack' & outcome != 'heart failure' & outcome != 'pneumonia') {
        cat('Error in best(\"',state,'\", \"', outcome,'\") : invalid outcome',sep='')
    }
    ## For each state, find the hospital of the given rank
    ## Return a data frame with the hospital names and the
    ## (abbreviated) state name
    else {
        data_return <- data.frame()
        for(state in levels(ds$State)) {
            tdata <- ds[ds[,7]==state,c(2,7,col_rank)]
            tdata[,3] <- as.numeric(as.character(tdata[,3]))
            tdata <- tdata[!is.na(tdata[3]),]
            
            tdata<-tdata[order(tdata[,1],decreasing=F),]
            tdata<-tdata[order(tdata[,3],decreasing=F),]
            tdata$rank <- c(1:nrow(tdata))
            num_r <- num
            switch(num,
                   best={num_r <- 1},
                   worst={num_r <- sum(!is.na(tdata[3]))}
            )
            if (num_r>nrow(tdata)) {
                data_return <- rbind(data_return, data.frame(State=state, Hospital.Name = "NA", rank=tdata[num_r,"rank"] ))
            } else {
                data_return <- rbind(data_return,data.frame(State=state, Hospital.Name=tdata[num_r, 1], rank=tdata[num_r,"rank"]))    
            }
            
        }
        #data_return <- data_return[order(data_return[,1],decreasing=F),]
        data_return <- data_return[,c(2,1)]
        colnames(data_return) <- c("hospital","state")
        data_return
        
    }
}

# Tests
head(rankall("heart attack", 20), 10)
tail(rankall("pneumonia", "worst"), 3)
tail(rankall("heart failure"), 10)
