## Reads the features.txt file that lists the subjects' measurement labels. The resulting data frame has the empty column. removed and is tranposed to match the following datasets. 
setwd("C:/Users/Matt/Documents/Data Science Specialization/3. Getting and Cleaning Data/UCI HAR Dataset")
features <- read.table("features.txt")   
features$V1 <- NULL
features <- t(features)

## Reads the training datasets.
setwd("C:/Users/Matt/Documents/Data Science Specialization/3. Getting and Cleaning Data/UCI HAR Dataset/train")
trainDS <- read.table("X_train.txt") 
train_activities <- read.table("y_train.txt")
subjectID1 <- read.table("subject_train.txt")   

## Binds the subjects activities with the subjects measurements, the binds the subject's IDs with the training dataset. 
trainDS <- cbind(train_activities, trainDS)
colnames(trainDS)[1] <- "Activities"
trainDS <- cbind(subjectID1, trainDS)
colnames(trainDS)[1] <- "SubjectID"

## Reads the testing datasets.
setwd("C:/Users/Matt/Documents/Data Science Specialization/3. Getting and Cleaning Data/UCI HAR Dataset/test")
testDS <- read.table("X_test.txt")
test_activities <- read.table("y_test.txt")
subjectID2 <- read.table("subject_test.txt")    

## Binds the subjects activities with the subjects measurements, the binds the subject's IDs with the testing dataset. Also renames the columns to the rational labels.
testDS <- cbind(test_activities, testDS)
colnames(testDS)[1] <- "Activities"
testDS <- cbind(subjectID2, testDS)
colnames(testDS)[1] <- "SubjectID"

## Binds the training and datasets (step 1).
dataset <- rbind(testDS, trainDS)
  
## Labels the data set with descriptive variable names (step 4).
names(dataset)[3:563]<- c(features)

## Extracts only the measurements on the mean and standard deviation for each measurement. It was assumed that the only measurements that are a mean contain "-mean()" and those that are a standard deviation contain "-std()" (step 2).
dataset <- dataset[ , c(1,2, grep("-mean()", colnames(dataset)), grep("-std()", colnames(dataset)))]
  
## Renames the descriptive activity names from numbers to names (step 3).
dataset$Activities[dataset$Activities == 1] = 'WALKING'
dataset$Activities[dataset$Activities == 2] = 'WALKING_UPSTAIRS'
dataset$Activities[dataset$Activities == 3] = 'WALKING_DOWNSTAIRS'
dataset$Activities[dataset$Activities == 4] = 'SITTING'
dataset$Activities[dataset$Activities == 5] = 'STANDING'
dataset$Activities[dataset$Activities == 6] = 'LAYING'

## Creates a second, independent tidy data set with the average of each variable for each activity and each subject (step 5). The dataset is named tidy_dataset.txt. 
library(plyr)
dataset1 <- ddply(dataset, c("SubjectID", "Activities"), numcolwise(mean))
setwd("C:/Users/Matt/Documents/Data Science Specialization/3. Getting and Cleaning Data/UCI HAR Dataset")
write.table(tidy_dataset, "tidy_dataset.txt")