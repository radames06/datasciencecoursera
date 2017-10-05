## DataCleaning course - Week 4
## Project assignment
##
## The purpose of this project is to demonstrate 
##      ability to collect, work with, and clean a data set

library(dplyr)

# Question 1 : Merges the training and the test sets to create one data set
# Loading test files
subject_test <- read.table('Dataset/test/subject_test.txt')
X_test <- read.fwf('Dataset/test/X_test.txt', widths=rep(16,561))
y_test <- read.table('Dataset/test/y_test.txt')
# Loading train files
subject_train <- read.table('Dataset/train/subject_train.txt')
X_train <- read.fwf('Dataset/train/X_train.txt', widths=rep(16,561))
y_train <- read.table('Dataset/train/y_train.txt')
# Merging test and train files
subject <- rbind(subject_test, subject_train)
X <- rbind(X_test, X_train)
y <- rbind(y_test, y_train)

# Question 2 : Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table('Dataset/features.txt', sep=' ')
col_to_select <- features[grep('mean|std',features$V2),1]
X <- X[,col_to_select]

# Question 3 : Uses descriptive activity names to name the activities in the data set
activity <- read.table('Dataset/activity_labels.txt', sep=' ')
y <- merge(y, activity, by.x='V1', by.y='V1')

# Question 4 : Appropriately labels the data set with descriptive variable names.
col_labels <- features[grep('mean|std',features$V2),2]
names(X) <- col_labels
names(y) <- c('activity.code','activity.name')

# Question 5 : From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
names(subject) <- 'subject'
X_tmp <- cbind(subject, y, X)
X_tmp <- select(X_tmp, -activity.code)
X_tmp <- group_by(X_tmp, activity.name, subject)
X_summarized <- summarise_all(X_tmp, funs(mean))
write.table(X_summarized, file='X_summarized.txt', row.names = FALSE)
