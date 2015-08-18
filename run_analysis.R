
# Course Project - Getting and Cleaning Data


#comment v
message("Download reshape2 library")
#
require("reshape2")

#comment v
message("Check the data path")
#
rawDataLocation <- "./data"
if (!file.exists(rawDataLocation)) { dir.create(rawDataLocation) }

#comment v
message("Checking if the data set archive was already downloaded...")

fileName <- "Dataset.zip"
filePath <- paste(rawDataLocation,fileName,sep="/")
if (!file.exists(filePath)) { 
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    message("Downloading the raw dataset")
    download.file(url=fileURL,destfile=filePath,method="curl")
}

#comment v
message("Timestamp data set archive file")

fileConn <- file(paste(filePath,".timestamp",sep=""))
writeLines(date(), fileConn)
close(fileConn)

#comment v
message("Extract the dataset files from the archive...")

unzip(zipfile=filePath, exdir=rawDataLocation)

# Set the data path of the extracted archive files...
dataSetPath <- paste(dataSetPath,"UCI HAR Dataset",sep="/")

#comment v
message("Read training & test column files into x,y,s variables")

xTrain <- read.table(file=paste(dataSetPath,"/train/","X_train.txt",sep=""),header=FALSE)
xTest  <- read.table(file=paste(dataSetPath,"/test/","X_test.txt",sep=""),header=FALSE)
yTrain <- read.table(file=paste(dataSetPath,"/train/","y_train.txt",sep=""),header=FALSE)
yTest  <- read.table(file=paste(dataSetPath,"/test/","y_test.txt",sep=""),header=FALSE)
sTrain <- read.table(file=paste(dataSetPath,"/train/","subject_train.txt",sep=""),header=FALSE)
sTest  <- read.table(file=paste(dataSetPath,"/test/","subject_test.txt",sep=""),header=FALSE)

#comment v
message("Read feaure names and sets column/variable names")

features <- read.table(file=paste(dataSetPath,"features.txt",sep="/"),header=FALSE)
names(xTrain) <- features[,2]
names(xTest)  <- features[,2]
names(yTrain) <- "Class_Label"
names(yTest)  <- "Class_Label"
names(sTest)  <- "SubjectID"
names(sTrain) <- "SubjectID"

#comment v
message("Merge (appending) the training and test data set rows...")
xData <- rbind(xTrain, xTest)
yData <- rbind(yTrain, yTest)
sData <- rbind(sTrain, sTest)

#comment v

data <- cbind(xData, yData, sData)

#comment v
message("Extract measurements on mean & standard deviation")

matchingColumns <- grep("mean|std|Class|Subject", names(data))
data <- data[,matchingColumns]

#comment v
message("Use descriptive activity names to name the activities in dataset")

activityNames <- read.table(file=paste(dataSetPath,"activity_labels.txt",sep="/"),header=FALSE)
names(activityNames) <- c("Class_Label", "Class_Name")
data <- merge(x=data, y=activityNames, by.x="Class_Label", by.y="Class_Label" )

#comment v
message("Label data with descriptive variable names")

names(data) <- gsub(pattern="[()]", replacement="", names(data))

#comment v
 
names(data) <- gsub(pattern="[-]", replacement="_", names(data))

#comment v
message("Remove columns")

data <- data[,!(names(data) %in% c("Class_Label"))]

#comment v
message("User reshape2 library to melt the dataset")

meltdataset <- melt(data=data, id=c("SubjectID", "Class_Name"))



finalTidyData <- dcast(data=meltdataset, SubjectID + Class_Name ~ variable, mean)

#comment v
message("Output the tidy dataset")

finalTidyFilePath <- paste(rawDataLocation,"TidyDataSet.txt",sep="/")
write.csv(finalTidyData, file=finalTidyFilePath, row.names=FALSE)

message("Completed")
