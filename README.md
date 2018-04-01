# GettingandCleaningDataCourseProject README

## Purpose
The purpose of this repo is to submit the Week 4 [assignment](https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project) of the Getting and Cleaning Data Course in the Coursera class on Data Science by Johns Hopkins University.

## Data background
Per the assignment, "the data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone." There are two main sets of data - a training set and a test set. Each set contains accelerometer measurements for a variety of metrics for thirty (30) subjects doing six different physical activities:
* Walking
* Walking upstairs
* Walking downstairs
* Sitting
* Standing
* Laying

There are also additional files that are part of the data set that are used to label the metrics. These include:
* Activity labels -- actual activity names that correspond to an activity number 
* Features -- column headers for all of the accelerometer metrics
* Features info -- description of the column headers above
* Subject train/test -- subject numbers for each observation
* X train/test -- measurements
* Y train/test -- activity numbers associated with each observation

The metrics include but are not limited to acceleration of the body, by gravity in each of the three X, Y, Z dimensions, rotational acceleration, and jerk movements analyzed over time and using a fourier transform method.

## What the code does
Per the assignment, run_analysis.R merges the training and data sets together and creates and writes a separate tidy data set that takes the average of all mean and standard deviation accelerometer metrics. The follow is taken from the assignment, with subheaders that I added to describe what I did:

* Merges the training and the test sets to create one data set.
  * read in all data files, including the activity numbers (y_train/test), measurements (x_train/test), subject numbers (subject_train/test), measurement column headers (subject_train/test), for both training and test files
  * used rbind and cbind to combine all of the above together
  * added columns headers for Subject and Activity
* Extracts only the measurements on the mean and standard deviation for each measurement.
  * Uses grep to find and extract only those headers with mean or std in them
* Uses descriptive activity names to name the activities in the data set
  * merges together the activity names using the merge function, then leave out the original activity number column
* Appropriately labels the data set with descriptive variable names.
  * remove all instances of "-" and "()"
  * capitalize mean and std
  * eliminate duplicate of BodyBody typos in original column headers
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  * using dplyr functions, grouped the data by activity and subject, summarized over each group by mean, and then arranged by subject and activity name
  * write to a separate file called finalDt.txt, which can be accessed using the following script
  
```
data <- read.table("finalDt.txt, header = TRUE) 
View(data)
```


## Why the resulting is tidy
The final dataset was created with tidy data principles from [Hadley Wickham](http://vita.had.co.nz/papers/tidy-data.pdf) and from the [thoughtfulbloke](https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/).

Wickham:
1. Each variable forms a column.
2. Each observation forms a row.
3. Each type of observational unit forms a table

Thoughtfulbloke:
1. Does it have headings so readers know which columns are which.
2. Are the variables in different columns (depending on the wide/long form)
3. Are there no duplicate columns

The final data table starts with Subject and Activity Name, essentially who did what, followed by the measurement data. The measurement data are generally arranged by time vs fourier, regular vs jerk movements, body vs gravity, mean vs standard deviation, linear vs gyroscopic metion, and the suffixes with directional dimensions (XYZ). More detail can be found in the code book. Each column is discrete and independent to itself, allowing them to be tidy variables. Each row is considered an observation and the final table is considered to be a single observational unit (initially, the activity labels table is a separate observational unit compared to the main table with all the accelerometer metrics). Nearly all headings were modified to be more readable and can be referenced in the code book.



