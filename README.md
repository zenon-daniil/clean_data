Getting and Cleaning Data Course Project
========================================

*Data merge 

First we need to merge  the training and the test sets to create one data set.
```{r, message=FALSE, warning=FALSE}
library(data.table)
library(dplyr)
wd <- "/Users/daniillebedev/Desktop/Getting and Cleaning data/UCI HAR Dataset/"
testwd <- "/Users/daniillebedev/Desktop/Getting and Cleaning data/UCI HAR Dataset/test/"
trainwd <- "/Users/daniillebedev/Desktop/Getting and Cleaning data/UCI HAR Dataset/train/"
test_x <- read.table(file.path(testwd, "X_test.txt"),header = FALSE)
test_y <- read.table(file.path(testwd, "y_test.txt"),header = FALSE)
test_subj <- read.table(file.path(testwd, "subject_test.txt"),header = FALSE)
train_x <- read.table(file.path(trainwd, "X_train.txt"),header = FALSE)
train_y <- read.table(file.path(trainwd, "y_train.txt"),header = FALSE)
train_subj <- read.table(file.path(trainwd, "subject_train.txt"),header = FALSE)
feat <- read.table(file.path(wd, "features.txt"),header = FALSE)
act_labl = read.table(file.path(wd, "activity_labels.txt"),header = FALSE)
colnames(test_x) <- feat[,2]
colnames(test_y) <- "act_id"
colnames(test_subj) <- "subj_id"
colnames(train_x) <- feat[,2]
colnames(train_y) <- "act_id"
colnames(train_subj) <- "subj_id"
colnames(act_labl) <- c('act_id','act_type')
subj <- rbind(train_subj, test_subj)
act_y <- rbind(train_y, test_y)
feat_x <- rbind(train_x, test_x)
colnames(subj) <- "SubjectID"
colnames(act_y) <- "ActivityID"
colnames(feat_x) <- t(feat[2])
data_merged <- cbind(feat_x,act_y,subj)
```

*Extracting variables of interest

Next we exctract only the measurements on the mean and standard deviation for each measurement.
```{r}
feat_mean_std <- feat_x$V2[grep("mean\\(\\)|std\\(\\)", feat_x$V2)]
names_feat <- c(as.character(feat_mean_std), "SubjectID", "ActivityID" )
data_mean_std <- subset(data_merged,select=names_feat)
```

*Adding descriptive variable names 

Next we labele the data set with appropriate descriptive variable names.
```{r}
columns = colnames(data_merged)
data_mean_std <- (grepl("ActivityID" , columns) | grepl("SubjectID" , columns) | grepl("mean.." , columns) | grepl("std.." , columns))
data_mean_std_1 <- data_merged[ , data_mean_std == TRUE]
```

*Activity names

We assign descriptive activity names to name the activities in the data set
```{r}
data_mean_std_1$ActivityID[data_mean_std_1$ActivityID == '1'] <- 'WALKING'
data_mean_std_1$ActivityID[data_mean_std_1$ActivityID == '2'] <- 'WALKING_UPSTAIRS'
data_mean_std_1$ActivityID[data_mean_std_1$ActivityID == '3'] <- 'WALKING_DOWNSTAIRS'
data_mean_std_1$ActivityID[data_mean_std_1$ActivityID == '4'] <- 'SITTING'
data_mean_std_1$ActivityID[data_mean_std_1$ActivityID == '5'] <- 'STANDING'
data_mean_std_1$ActivityID[data_mean_std_1$ActivityID == '6'] <- 'LAYING'
table(data_mean_std_1$ActivityID)
```
*Tidy dataste composition

We create independent tidy data set with the average of each variable for each activity and each subject.
```{r}
data_tidy <- aggregate(. ~SubjectID + ActivityID, data_mean_std_1, mean)
data_tidy_1 <- data_tidy[order(data_tidy$SubjectID, data_tidy$ActivityID),]
write.table(data_tidy_1, "/Users/daniillebedev/Desktop/Getting and Cleaning data/UCI HAR Dataset/Tidy.txt", row.name=FALSE)
```
