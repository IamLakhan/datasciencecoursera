## Getting and Cleaning Data Project Week 4
## Author: Lakhan Gurbani


## First get (x, y and subject) train and test files (txt) 
## features.txt activity_labels.txt file in same directory as this file
## Set the source as run_analysis.R and  run it.
## The script will create a tidy data in the working directory

## Importing required packages
library(data.table)
library(reshape2)

## Reading and storing the data
features <- read.table('features.txt')
activity <- read.table('activity_labels.txt', col.names = c('classLabels', 'activityName'))

subject_test <- read.table('subject_test.txt', col.names = 'SubjectNum')
subject_train <- read.table('subject_train.txt', col.names = 'SubjectNum')

x_test <- read.table('X_test.txt')
y_test <- read.table('y_test.txt', col.names = 'Activity')

x_train <- read.table('X_train.txt')
y_train <- read.table('y_train.txt', col.names = 'Activity')

## Merging the sets to create one set
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
MergedDT <- cbind(Subject, Y, X)

## Giving Proper Names to names in data set
MergedDT[["Activity"]] <- factor(MergedDT[,'Activity'],
                                 levels = activity[['classLabels']],
                                 labels = activity[['activityName']])

MergedDT[['SubjectNum']] <- as.factor(MergedDT[, 'SubjectNum'])
MergedDT <- reshape2::melt((data = MergedDT))
MergedDT <- reshape2::dcast(data = MergedDT, SubjectNum + Activity ~ variable, fun.aggregate = mean)


data.table::fwrite(x = MergedDT, file = "tidyData.txt", quote = FALSE)

