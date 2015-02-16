# run_analysis.R
# A script designed for the final project in Getting and Cleaning Data
# Last modified 02152015  by jhp
#
#Set up file names for data reads
activities_file <- "activity_labels.txt"  #activities file name
features_file <- "features.txt"    #features file name
subjecttest_file <- "subject_test.txt"   #subject test file name
subjecttrain_file <- "subject_train.txt"  #subject training file name
xtest_file<- "X_test.txt"    #xtest file name
xtrain_file <- "X_train.txt"    #xtrain file name
ytest_file <- "y_test.txt"    #ytest file name
ytrain_file <- "y_train.txt"    #ytrain file name

# read in selected files
#
features <- read.table(features_file, na.strings = "NA") # Read features
subjecttest <- read.table(subjecttest_file, na.strings = "NA")#Read Subject test file
subjecttrain <- read.table(subjecttrain_file, na.strings = "NA")#Read subject training file name
xtest<- read.table(xtest_file, na.strings = "NA") #Read xtest file
xtrain <- read.table(xtrain_file, na.strings = "NA") #Read xtrain file
ytest <- read.table(ytest_file, na.strings = "NA") #Read ytest file
ytrain <- read.table(ytrain_file, na.strings = "NA") #Read ytrain file
activities<- read.table(activities_file, na.strings = "NA") #Read Activities file
#
#Build the ytrain and ytest files by mergin with activities
ytst_merge <- merge(ytest,activities, by = "V1" )
ytrn_merge <- merge(ytrain,activities, by = "V1" )
rnames <- features$V2  #pull the labels from the features
#
#clean up the column names form the features files and name the xtrain and xtest files
rnames <- gsub("-","",rnames)
rnames <- gsub("\\()","",rnames)
rnames <- gsub(",","",rnames)
names(xtrain) <- rnames
names(xtest) <- rnames
#
#Prepare to build the subsetted files
#placing the reults in xtest_final and xtrain_final
remove <- grep("*Freq",features$V2)
vals <- grep("*mean",features$V2)
vals <- setdiff(vals,remove)
xtest_reduced1 <- xtest[,c(vals)]
xtrain_reduced1 <-xtrain[,c(vals)]
vals2 <- grep( "*std",features$V2)
xtest_reduced2 <- xtest[,c(vals2)]
xtrain_reduced2 <-xtrain[,c(vals2)]
xtest_final <- cbind(xtest_reduced1,xtest_reduced2)
xtrain_final<- cbind(xtrain_reduced1,xtrain_reduced2)
#
#name the ytest and ytrain, subject test and subjecttrain columns
ytst_header <- c("index", "activity")
ytrn_header <- c("index", "activity")
names(ytst_merge) <- ytst_header
names(ytrn_merge) <- ytrn_header
names(subjecttest) <- "subject_index"
names(subjecttrain) <- "subject_index"
# do the final combinations

train_temp <- cbind(subjecttrain,ytrn_merge)
test_tmp <- cbind(subjecttest,ytst_merge)
xtest_final <- cbind(test_tmp, xtest_final)
xtrain_final <- cbind(train_temp, xtrain_final)
combined <- rbind(xtest_final,xtrain_final)
#grouped_combine <- group_by(combined,"subject_index","activity")
# tidy_result will hold the aggregated tidy data set
tidy_result <- aggregate(combined[,4:69], by = list(combined[,1],combined[,3]), FUN = mean)
names(tidy_result)[1] <- paste("subject_index")
names(tidy_result)[2] <- paste("activity")
write.table(tidy_result, file ="result_file.txt", row.names = FALSE)
