# Submission for Coursera Data Science Specialization  
# Peer Graded Assignment: Getting and Cleaning Data Course Project
# This script requires dplyr package

# Read feature list and activity names
features_list <- read.table("UCI HAR Dataset/features.txt", col.names = c("no","features"))
activity <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("label", "activity"))

# Read test dataset and combine into one dataframe
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features_list$features)
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt", col.names = "label")
y_test_label <- left_join(y_test, activity, by = "label")

tidy_test <- cbind(subject_test, y_test_label, x_test)
tidy_test <- select(tidy_test, -label)


# Read train dataset
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features_list$features)
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt", col.names = "label")
y_train_label <- left_join(y_train, activity, by = "label")

tidy_train <- cbind(subject_train, y_train_label, x_train)
tidy_train <- select(tidy_train, -label)

# combine test and train data set
tidy_set <- rbind(tidy_test, tidy_train)

# Extract mean and standard deviation
tidy_mean_std <- select(tidy_set, contains("mean"), contains("std"))

# Averanging all variable by each subject each activity
tidy_mean_std$subject <- as.factor(tidy_set$subject)
tidy_mean_std$activity <- as.factor(tidy_set$activity)

FinalData <- tidy_mean_std %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

write.table(FinalData, "FinalData.txt", row.name=FALSE)