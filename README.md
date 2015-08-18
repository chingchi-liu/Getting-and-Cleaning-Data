# Getting-and-Cleaning-Data
# Course Project - Getting and Cleaning Data

## Instructions

Get run\_analysis.R script.
run\_analysis.R will download and process the data set generating a tidy data set at `./data/TidyDataSet.txt`

## Data Source

"Human Activity Recognition Using Smartphones Dataset" 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

run\_analysis.R will download the above raw data.


## Steps in Script

* Download reshape2 library
* Check if the data path exists (./data)
* Check if the dataset archive has been already downloaded. Download the data set archive if it was not already and timestamps the downloaded dataset archive file.
* Extract the dataset files from above archive and read training & test column files into x,y,s variables
* Read feaure names and sets column/variable names
* Append the training and test dataset
* Create a unified data set (data frame)
* Extract measurements on mean & standard deviation, for each measurement and set activity names on the class label.
* Label data with descriptive variable/column names by removing special characters in the column names and by cleaning up hyphen's with underscores in the column names
* Remove columns used only for tidying up the data set
* Melts the data set by reshape2 library
* For output purpose , create a second tidy data set which contains the average of each variable for each activity and subject
* Output the final tidy data set to file ./data/TidyDataSet.txt
