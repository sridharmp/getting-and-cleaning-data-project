# Downloaded the file manually from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
and unzipped the data Sets to 'UCI HAR Dataset' directory

#  Dealing with Activity Labels & Features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Mean and standard deviation data
stdMean <- grep(".*mean.*|.*std.*", features[,2])
stdMean.names <- features[stdMean,2]
stdMean.names = gsub('-mean', 'Mean', stdMean.names)
stdMean.names = gsub('-std', 'Std', stdMean.names)
stdMean.names <- gsub('[-()]', '', stdMean.names)


# Load the train and test datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[stdMean]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)
test <- read.table("UCI HAR Dataset/test/X_test.txt")[stdMean]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merge datasets and add labels
fullData <- rbind(train, test)
colnames(fullData) <- c("subject", "activity", stdMean.names)
fullData$activity <- factor(fullData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
fullData$subject <- as.factor(fullData$subject)
install.packages("reshape2")
library(reshape2)
fullData.mdata <- melt(fullData, id = c("subject", "activity"))
fullData.mean <- dcast(fullData.mdata, subject + activity ~ variable, mean)

#create the tidy.txt output data
write.table(fullData.mean, "tidy.txt", sep="\t", row.names = FALSE)