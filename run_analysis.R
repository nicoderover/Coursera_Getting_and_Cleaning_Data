# Coursera - Getting and Cleaning data
# Nico de Rover, derover.n@gmail.com

# 1) a tidy data set as described below,
# 2) a link to a Github repository with your script for performing the analysis, and 
# 3) a code book that describes the variables, the data, and any transformations or work that you
# performed to clean up the data called CodeBook.md.
# You should also include a README.md in the repo with your scripts. 
# This repo explains how all of the scripts work and how they are connected.

# 1. Merge the training and the test sets to create one data set
library(dplyr)
setwd("D:/PersonalData/DeRovNic/Desktop/Coursera/Getting and Cleaning Data Course Project")

# read in txt files
x_train <- read.table("data/X_train.txt")
y_train <- read.table("data/y_train.txt")
subject_train <- read.table("data/subject_train.txt")

x_test <- read.table("data/X_test.txt")
y_test <- read.table("data/y_test.txt")
subject_test <- read.table("data/subject_test.txt")

# create 'x' and 'y' and 'subject' data set by rbinding the train and test data sets
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# 2. Extract only the measurements on the mean and standard deviation for each measurement

# load in features text file
features <- read.table("data/features.txt")
# extract columns that have mean() or std() in their name only
mean_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
# create subset based on the above extracted mean and std rows
# in essence, we're filtering out those columns that are not a calculation of mean or std
x_data <- x_data[,mean_std_features]
# assign field names based on filtered features file
names(x_data) <- features[mean_std_features,2]

# 3. Use the descriptive activity names to name the activities in the data set

# load in file with activity labels
activities <- read.table("data/activity_labels.txt")
# substitute numbers with the respective activity label names
y_data[, 1] <- activities[y_data[, 1], 2]
# assign "activity" as the field name of the y_data dataset
names(y_data) <- "activity"

# 4. Appropriately label the data set with descriptive variable names

# assign "subject" as the field name for the subject_data dataset
names(subject_data) <- "subject"

# cbind columns from all three datasets into a single dataset
all_data <- cbind(x_data, y_data, subject_data)

# 5. From the data set in step 4, creates a second, independent tidy data 
# set with the average of each variable for each activity and each subject

# apply the ddply function to all_data and take the colMeans from all columns except the last two and
# split/group the table by subject and activity
averages <- ddply(all_data, .(subject, activity), function(x) colMeans(x[,1:66]))

# write table and save as text file
write.table(averages, "averages.txt", row.name = FALSE)








