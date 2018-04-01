library(dplyr)

#read in data, classifying them as integers for subject #'s and activity #'s, numeric for the measurements and character for the column headers
ytrain <- read.table("./projectdata/UCI HAR Dataset/train/y_train.txt", stringsAsFactors = FALSE, colClasses = "integer") #activity type by number, training data for each observation
xtrain <- read.table("./projectdata/UCI HAR Dataset/train/x_train.txt", stringsAsFactors = FALSE, colClasses = "numeric") #measurements, training data
subjecttrain <- read.table("./projectdata/UCI HAR Dataset/train/subject_train.txt", stringsAsFactors = FALSE, colClasses = "integer") #subject number for each observation, training data
features <- read.table("./projectdata/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE, colClasses = "character") #column headers
ytest <- read.table("./projectdata/UCI HAR Dataset/test/y_test.txt", stringsAsFactors = FALSE, colClasses = "integer") #activity type, test data
xtest <- read.table("./projectdata/UCI HAR Dataset/test/X_test.txt", stringsAsFactors = FALSE, colClasses = "numeric") #measurements, test data
subjecttest <- read.table("./projectdata/UCI HAR Dataset/test/subject_test.txt", stringsAsFactors = FALSE, colClasses = "integer") #subject number for each observation, test data

#1.Merges the training and the test sets to create one data set
#bind the training columns together, starting with subject, activity # (ytrain) and then the data
trainDt <- cbind(subjecttrain,ytrain, xtrain)
temp <- c("Subject", "Activity")
colnames(trainDt) <- c(temp, features[,2])
#optional: trainDt$TrainOrTest <- "training" #add a factor to label training data set

#bind the test columns together, starting with subject, activity # (ytest) and then the data
testDt <- cbind(subjecttest,ytest, xtest)
temp <- c("Subject", "Activity")
colnames(testDt) <- c(temp, features[,2])
#optional: testDt$TrainOrTest <- "test"  #add a factor to label test data set

#merge testing and training together
dt <- rbind(trainDt, testDt)

#2. Extracts only the measurements on the mean and standard deviation for each measurement and create a separate dt called stdmeanDt
stdmeancol <- grep("std|mean|TrainOrTest", colnames(dt)) #produces an index of columns that contain "std" or "mean" for stdev and mean, respectively
#including the TrainOrTest column if present
stdmeanDt <- dt[,c(1,2,stdmeancol)] #creates a new dt to select only those columns in stdmeancol

#3. Uses descriptive activity names to name the activities in the data set
#read in activity labels
activityDt <- read.table("./projectdata/UCI HAR Dataset/activity_labels.txt")
colnames(activityDt) <- c("Number", "ActivityName")

#merge activityDt and stdmeanDt based on the number label of the activity (the column "Number" in activityDt and "Activity" in stdmeanDt)
mergeDt <- merge(stdmeanDt, activityDt, by.x = "Activity", by.y = "Number", all = TRUE)
mergeDt <- select(mergeDt, -Activity) #remove Activity number column
      
#4.Appropriately labels the data set with descriptive variable names.
#use regular expressions and gsub to take out "-", "()", and capitalize "mean" and "std"

colnames(mergeDt) <- gsub("-|[()]","",colnames(mergeDt)) #delete - and ()
colnames(mergeDt) <- gsub("mean","Mean",colnames(mergeDt)) #capitalize mean
colnames(mergeDt) <- gsub("std","Std",colnames(mergeDt)) #capitalize std
colnames(mergeDt) <- gsub("BodyBody","Body",colnames(mergeDt)) #remove the extra BodyBody typo

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for
#each activity and each subject.

finDt <- mergeDt %>%
      group_by(Subject, ActivityName) %>%
      summarize_all(mean, na.rm = TRUE)

#write table to separate file
write.table(finDt, file = "finalDt.txt")


