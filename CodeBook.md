CodeBook.md
Data dictionary and run time descriptions

The script run_analysis.R contains individual variables that capture the data that is to be transformed at the various steps throughout the process. The script expects the data to be unzipped into the working directory of R.

The followings operations were performed on the data sets:
Define the file names to read the data files into.
Read the data into the appropriate data file(see def's below)
Merge the activities file with ytest.txt and ytrain.txt
Load the observation titles from the activities file
Clean up column names by removing “-” “,” “()” from the names
Use the cleaned names as the column names for xtest and xtrain
Remove all columns from the data set except those containing mean and std in the titles
Store the results in the xtest_final and the xtrain_final variables
Build the ytest ans ytrain column names using “index” and “activity”
Name the subject_test and subject_index columns
Perform the final merges of the data merging the required data sets for xtest_final and xtrain_final.
Tidy and reduce the results by taking the mean by test individual and activity.
Output the results to a text file “result_file.txt

Variable Dictionary


activities_file <- "activity_labels.txt"		#activities file name
features_file <- "features.txt"				#features file name
subjecttest_file <- "subject_test.txt"			#subject test file name
subjecttrain_file <- "subject_train.txt"		#subject training file name
xtest_file<- "X_test.txt"				#xtest file name
xtrain_file <- "X_train.txt"				#xtrain file name
ytest_file <- "y_test.txt"				#ytest file name
ytrain_file <- "y_train.txt"				#ytrain file name
features <- read.table(features_file, na.strings = "NA")	# Read features
subjecttest <- read.table(subjecttest_file, na.strings = "NA")#Read Subject test file
subjecttrain <- read.table(subjecttrain_file, na.strings = "NA")#Read subject training file name
xtest<- read.table(xtest_file, na.strings = "NA")	#Read xtest file
xtrain <- read.table(xtrain_file, na.strings = "NA")	#Read xtrain file
ytest <- read.table(ytest_file, na.strings = "NA")	#Read ytest file
ytrain <- read.table(ytrain_file, na.strings = "NA")	#Read ytrain file
activities<- read.table(activities_file, na.strings = "NA") #Read Activities file
ytst_merge <- merge(ytest,activities, by = "V1" )
ytrn_merge <- merge(ytrain,activities, by = "V1" )
rnames <- features$V2  #pull the labels from the features # load the lables into rnames
rnames <- gsub("-","",rnames)
rnames <- gsub("\\()","",rnames)
rnames <- gsub(",","",rnames)
names(xtrain) <- rnames	# name the columns
names(xtest) <- rnames
remove <- grep("*Freq",features$V2) 
#use remove, valse vals2 as holding values to reove columns from the data set
vals <- grep("*mean",features$V2)
vals <- setdiff(vals,remove)
xtest_reduced1 <- xtest[,c(vals)]
xtrain_reduced1 <-xtrain[,c(vals)]
vals2 <- grep( "*std",features$V2)
xtest_reduced2 <- xtest[,c(vals2)] 	# the pre-merged reduced files
xtrain_reduced2 <-xtrain[,c(vals2)]	# the pre-merged reduced files
xtest_final <- cbind(xtest_reduced1,xtest_reduced2) #Final holding variable for xtest data
xtrain_final<- cbind(xtrain_reduced1,xtrain_reduced2)#Final holding variable for xtraindata
ytst_header <- c("index", "activity")	
ytrn_header <- c("index", "activity")
names(ytst_merge) <- ytst_header
names(ytrn_merge) <- ytrn_header
names(subjecttest) <- "subject_index"
names(subjecttrain) <- "subject_index"
train_temp <- cbind(subjecttrain,ytrn_merge)
test_tmp <- cbind(subjecttest,ytst_merge)
xtest_final <- cbind(test_tmp, xtest_final)
xtrain_final <- cbind(train_temp, xtrain_final)
combined <- rbind(xtest_final,xtrain_final)
grouped_combine <- group_by(combined,"subject_index","activity")
# setwd("~/working")
# source("run_analysis.R")
