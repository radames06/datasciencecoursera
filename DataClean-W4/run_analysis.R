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
body_acc_x_test <- read.fwf('Dataset/test/Inertial Signals/body_acc_x_test.txt', widths=rep(16,2048/16))
body_acc_y_test <- read.fwf('Dataset/test/Inertial Signals/body_acc_y_test.txt', widths=rep(16,2048/16))
body_acc_z_test <- read.fwf('Dataset/test/Inertial Signals/body_acc_z_test.txt', widths=rep(16,2048/16))
body_gyro_x_test <- read.fwf('Dataset/test/Inertial Signals/body_gyro_x_test.txt', widths=rep(16,2048/16))
body_gyro_y_test <- read.fwf('Dataset/test/Inertial Signals/body_gyro_y_test.txt', widths=rep(16,2048/16))
body_gyro_z_test <- read.fwf('Dataset/test/Inertial Signals/body_gyro_z_test.txt', widths=rep(16,2048/16))
total_acc_x_test <- read.fwf('Dataset/test/Inertial Signals/total_acc_x_test.txt', widths=rep(16,2048/16))
total_acc_y_test <- read.fwf('Dataset/test/Inertial Signals/total_acc_y_test.txt', widths=rep(16,2048/16))
total_acc_z_test <- read.fwf('Dataset/test/Inertial Signals/total_acc_z_test.txt', widths=rep(16,2048/16))

# Loading train files
subject_train <- read.table('Dataset/train/subject_train.txt')
X_train <- read.fwf('Dataset/train/X_train.txt', widths=rep(16,561))
y_train <- read.table('Dataset/train/y_train.txt')
body_acc_x_train <- read.fwf('Dataset/train/Inertial Signals/body_acc_x_train.txt', widths=rep(16,2048/16))
body_acc_y_train <- read.fwf('Dataset/train/Inertial Signals/body_acc_y_train.txt', widths=rep(16,2048/16))
body_acc_z_train <- read.fwf('Dataset/train/Inertial Signals/body_acc_z_train.txt', widths=rep(16,2048/16))
body_gyro_x_train <- read.fwf('Dataset/train/Inertial Signals/body_gyro_x_train.txt', widths=rep(16,2048/16))
body_gyro_y_train <- read.fwf('Dataset/train/Inertial Signals/body_gyro_y_train.txt', widths=rep(16,2048/16))
body_gyro_z_train <- read.fwf('Dataset/train/Inertial Signals/body_gyro_z_train.txt', widths=rep(16,2048/16))
total_acc_x_train <- read.fwf('Dataset/train/Inertial Signals/total_acc_x_train.txt', widths=rep(16,2048/16))
total_acc_y_train <- read.fwf('Dataset/train/Inertial Signals/total_acc_y_train.txt', widths=rep(16,2048/16))
total_acc_z_train <- read.fwf('Dataset/train/Inertial Signals/total_acc_z_train.txt', widths=rep(16,2048/16))

# Merging test and train files
subject <- rbind(subject_test, subject_train)
X <- rbind(X_test, X_train)
y <- rbind(y_test, y_train)
body_acc_x <- rbind(body_acc_x_test, body_acc_x_train)
body_acc_y <- rbind(body_acc_y_test, body_acc_y_train)
body_acc_z <- rbind(body_acc_z_test, body_acc_z_train)
body_gyro_x <- rbind(body_gyro_x_test, body_gyro_x_train)
body_gyro_y <- rbind(body_gyro_y_test, body_gyro_y_train)
body_gyro_z <- rbind(body_gyro_z_test, body_gyro_z_train)
total_acc_x <- rbind(total_acc_x_test,total_acc_x_train)
total_acc_y <- rbind(total_acc_y_test, total_acc_y_train)
total_acc_z <- rbind(total_acc_z_test,total_acc_z_train)

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
