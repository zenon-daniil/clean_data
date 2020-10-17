library(data.table)
library(dplyr)

#task1

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

#task2

subj <- rbind(train_subj, test_subj)
act_y <- rbind(train_y, test_y)
feat_x <- rbind(train_x, test_x)
colnames(subj) <- "SubjectID"
colnames(act_y) <- "ActivityID"
colnames(feat_x) <- t(feat[2])
data_merged <- cbind(feat_x,act_y,subj)
feat_mean_std <- feat_x$V2[grep("mean\\(\\)|std\\(\\)", feat_x$V2)]
names_feat <- c(as.character(feat_mean_std), "SubjectID", "ActivityID" )
data_mean_std <- subset(data_merged,select=names_feat)

#task3

columns = colnames(data_merged)
data_mean_std <- (grepl("ActivityID" , columns) | grepl("SubjectID" , columns) | grepl("mean.." , columns) | grepl("std.." , columns))
data_mean_std_1 <- data_merged[ , data_mean_std == TRUE]

#task4

data_mean_std_1$ActivityID[data_mean_std_1$ActivityID == '1'] <- 'WALKING'
data_mean_std_1$ActivityID[data_mean_std_1$ActivityID == '2'] <- 'WALKING_UPSTAIRS'
data_mean_std_1$ActivityID[data_mean_std_1$ActivityID == '3'] <- 'WALKING_DOWNSTAIRS'
data_mean_std_1$ActivityID[data_mean_std_1$ActivityID == '4'] <- 'SITTING'
data_mean_std_1$ActivityID[data_mean_std_1$ActivityID == '5'] <- 'STANDING'
data_mean_std_1$ActivityID[data_mean_std_1$ActivityID == '6'] <- 'LAYING'
table(data_mean_std_1$ActivityID)

#task5

data_tidy <- aggregate(. ~SubjectID + ActivityID, data_mean_std_1, mean)
data_tidy_1 <- data_tidy[order(data_tidy$SubjectID, data_tidy$ActivityID),]
write.table(data_tidy_1, "/Users/daniillebedev/Desktop/Getting and Cleaning data/UCI HAR Dataset/Tidy.txt", row.name=FALSE)
