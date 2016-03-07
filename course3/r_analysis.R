#Extract all the files from the folder
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files

library(plyr);
###############################################################################
#Merge the training and test sets to create one data set
#Read all the activity, subject and Feature files
ytest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
ytrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
subjecttrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
subjecttest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
xtest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
xtrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)


subject <- rbind(subjecttrain, subjecttest)
Activity<- rbind(ytrain, ytest)
Features<- rbind(xtrain, xtest)

names(subject)<-c("subject")
names(Activity)<- c("activity")
FeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(Features)<-FeaturesNames$V2
dataCombine <- cbind(subject, Activity)
Data <- cbind(Features, dataCombine)
############################################################################################

###############################################################################################
#Extracts only the measurements on the mean and standard deviation for each measurement
dataFeaturesNames<-FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]
selectedNames<-c(as.character(dataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
str(Data)
#############################################################################################

##############################################################################################
#Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
head(Data$activity,30)
############################################################################################

##############################################################################################
#Appropriately labels the data set with descriptive variable names.
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

names(Data)
###############################################################################################

#############################################################################################
#Creates a second,independent tidy data set and ouput it
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "datarefined.txt",row.name=FALSE)
#################################################################################################3

