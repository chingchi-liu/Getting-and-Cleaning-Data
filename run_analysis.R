# Course Project - Getting and Cleaning Data

require("reshape2")


rawDataLocation <- "./data"
if (!file.exists(rawDataLocation)) { dir.create(rawDataLocation) }


fileName <- "Dataset.zip"
filePath <- paste(rawDataLocation,fileName,sep="/")
if (!file.exists(filePath)) { 
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  message("Downloading the raw dataset")
  download.file(url=fileURL,destfile=filePath,method="curl")
}


fileConn <- file(paste(filePath,".timestamp",sep=""))
writeLines(date(), fileConn)
close(fileConn)


unzip(zipfile=filePath, exdir=rawDataLocation)

# Set the data path of the extracted archive files...
dataSetPath <- paste(dataSetPath,"UCI HAR Dataset",sep="/")


xTrain <- read.table(file=paste(dataSetPath,"/train/","X_train.txt",sep=""),header=FALSE)
xTest  <- read.table(file=paste(dataSetPath,"/test/","X_test.txt",sep=""),header=FALSE)
yTrain <- read.table(file=paste(dataSetPath,"/train/","y_train.txt",sep=""),header=FALSE)
yTest  <- read.table(file=paste(dataSetPath,"/test/","y_test.txt",sep=""),header=FALSE)
sTrain <- read.table(file=paste(dataSetPath,"/train/","subject_train.txt",sep=""),header=FALSE)
sTest  <- read.table(file=paste(dataSetPath,"/test/","subject_test.txt",sep=""),header=FALSE)

features <- read.table(file=paste(dataSetPath,"features.txt",sep="/"),header=FALSE)
names(xTrain) <- features[,2]
names(xTest)  <- features[,2]
names(yTrain) <- "Class_Label"
names(yTest)  <- "Class_Label"
names(sTest)  <- "SubjectID"
names(sTrain) <- "SubjectID"


xData <- rbind(xTrain, xTest)
yData <- rbind(yTrain, yTest)
sData <- rbind(sTrain, sTest)

data <- cbind(xData, yData, sData)

matchingColumns <- grep("mean|std|Class|Subject", names(data))
data <- data[,matchingColumns]

activityNames <- read.table(file=paste(dataSetPath,"activity_labels.txt",sep="/"),header=FALSE)
names(activityNames) <- c("Class_Label", "Class_Name")
data <- merge(x=data, y=activityNames, by.x="Class_Label", by.y="Class_Label" )


names(data) <- gsub(pattern="[()]", replacement="", names(data))

names(data) <- gsub(pattern="[-]", replacement="_", names(data))


data <- data[,!(names(data) %in% c("Class_Label"))]


meltdataset <- melt(data=data, id=c("SubjectID", "Class_Name"))

finalTidyData <- dcast(data=meltdataset, SubjectID + Class_Name ~ variable, mean)

finalTidyFilePath <- paste(rawDataLocation,"TidyDataSet.txt",sep="/")
write.csv(finalTidyData, file=finalTidyFilePath, row.names=FALSE)

message("Completed")
