
TKTK Example - https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

## Variables

My dataset is made up of three types of variables.  Below I will provide the labels and the descriptions of each type.

1. activity
	This data was originally provided in the raw UCI HAR Dataset (described and linked below) in the form of a number 1-6.
	The values presented in my submission dataset came from the activity_labels.txt provided by the raw UCI HAR Dataset (described below)
2. subject
	This value was originally provided in the raw UCI HAR Dataset (described and linked below).  
	The values presented in my submission dataset are the values provided in the original dataset.
3. features
	The featues make up the rest of the columns of the dataset.  
	The features presented in my submissions are only those which represent means and standard deviations of observations.
	The names of the columns come from the raw UCI HAR Dataset.
	The names are described in the features_info.txt from the original dataset.  I have not modified them, as they contain necessary information for future analysis.
	



## Data Dictionary

activity
	Activities performed by the subjects come from the following list. 
		WALKING
		WALKING_UPSTAIRS
		WALKING_DOWNSTAIRS
		SITTING
		STANDING
		LAYING
subject
	Label for each subject.  All that is known is the label for the subject
		1...30

features
	Labels contain four pieces of information separated by dashes '-'.  
	Some modifications of the labels - as described here - were added for clarity.
	There is much more information about what the raw measurements meant in features_info.txt

	1. time or frequency 	- replaces 't' or 'f', respectively, from original labels
	2. measurement 			- what was measured or calculated
	3. mean or std 			- the value is a mean or standard deviation
	4. x, y, or z 			- (optional) if the value calculated is along the x, y, or z axis
		
	List of features included	
		time-bodyacceleration-mean-x
		time-bodyacceleration-mean-y
		time-bodyacceleration-mean-z
		time-bodyacceleration-std-x
		time-bodyacceleration-std-y
		time-bodyacceleration-std-z
		time-gravityacceleration-mean-x
		time-gravityacceleration-mean-y
		time-gravityacceleration-mean-z
		time-gravityacceleration-std-x
		time-gravityacceleration-std-y
		time-gravityacceleration-std-z
		time-bodyaccelerationjerk-mean-x
		time-bodyaccelerationjerk-mean-y
		time-bodyaccelerationjerk-mean-z
		time-bodyaccelerationjerk-std-x
		time-bodyaccelerationjerk-std-y
		time-bodyaccelerationjerk-std-z
		time-bodygyro-mean-x
		time-bodygyro-mean-y
		time-bodygyro-mean-z
		time-bodygyro-std-x
		time-bodygyro-std-y
		time-bodygyro-std-z
		time-bodygyrojerk-mean-x
		time-bodygyrojerk-mean-y
		time-bodygyrojerk-mean-z
		time-bodygyrojerk-std-x
		time-bodygyrojerk-std-y
		time-bodygyrojerk-std-z
		time-bodyaccelerationmagnitude-mean
		time-bodyaccelerationmagnitude-std
		time-gravityaccelerationmagnitude-mean
		time-gravityaccelerationmagnitude-std
		time-bodyaccelerationjerkmagnitude-mean
		time-bodyaccelerationjerkmagnitude-std
		time-bodygyromagnitude-mean
		time-bodygyromagnitude-std
		time-bodygyrojerkmagnitude-mean
		time-bodygyrojerkmagnitude-std
		frequency-bodyacceleration-mean-x
		frequency-bodyacceleration-mean-y
		frequency-bodyacceleration-mean-z
		frequency-bodyacceleration-std-x
		frequency-bodyacceleration-std-y
		frequency-bodyacceleration-std-z
		frequency-bodyaccelerationjerk-mean-x
		frequency-bodyaccelerationjerk-mean-y
		frequency-bodyaccelerationjerk-mean-z
		frequency-bodyaccelerationjerk-std-x
		frequency-bodyaccelerationjerk-std-y
		frequency-bodyaccelerationjerk-std-z
		frequency-bodygyro-mean-x
		frequency-bodygyro-mean-y
		frequency-bodygyro-mean-z
		frequency-bodygyro-std-x
		frequency-bodygyro-std-y
		frequency-bodygyro-std-z
		frequency-bodyaccelerationmagnitude-mean
		frequency-bodyaccelerationmagnitude-std
		frequency-bodyaccelerationjerkmagnitude-mean
		frequency-bodyaccelerationjerkmagnitude-std
		frequency-bodygyromagnitude-mean
		frequency-bodygyromagnitude-std
		frequency-bodygyrojerkmagnitude-mean
		frequency-bodygyrojerkmagnitude-std

## Transformations & Clean Up Steps

1. Merge subject, activity, and observation data together.  
This step creates a data set which includes the above listed columns (plus more features which are not means or standard deviations)

The following files were used to create the combined data set.
UCI HAR Dataset/train/subject_train.txt  (subject label)
UCI HAR Dataset/train/y_train.txt  (activity label)
UCI HAR Dataset/train/X_train.txt  (features)

UCI HAR Dataset/test/subject_test.txt    (subject label)
UCI HAR Dataset/test/y_test.txt   (activity label)
UCI HAR Dataset/test/X_test.txt   (features)

2. Extract only the measurements on the mean and standard deviation for each measurement
This step creates a subset of columns based on wether or not the measurement is a mean or standard deviation.
Subject and Activity labels are also included.

3. Use descriptive activity names to name the activities in the data set
This step replaces the activity label number values provided in the training and test sets with the descriptive values provided in the following file (from the raw data).

UCI HAR Dataset/activity_labels.txt

4.  Appropriately label the data set with descriptive variable names.
In this step I performed a few replacements on the raw column names to make them a bit more descriptive and easier to read.
The list of changes taken is below.

  #  replace beginning 't' with 'time-' and 'f' with 'frequency-'
  #  replace 'Mag' with 'magnitude'
  #  reaplce 'Acc' with 'acceleration'
  #  remove the parentheses
  #  remove dashes
  #  replace "BodyBody" with "Body" in the mis labeled variables from the original data
  #  lowercase variable names

5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
  In this step I grouped the data by activity and then subject and then used the function summarize_each in order to apply the mean to each variable NOT grouped (which is all of the features.)

  The final dataset has a row for each activity - subject pair.
  The final dataset's features are the mean of the values for each activity - subject pair.



### Raw Data
	UCI HAR Dataset 
	Raw data was downloaded 
		- August 17, 2016
	Raw data was obtained from the following link
		- https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
	A description of the raw data is available from the following link  
		- http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

