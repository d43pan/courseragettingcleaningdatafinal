
Welcome to my final project for the Getting and Cleaning Data Course.  

My goals for this project submission are:
- to be clear with the steps I took
- to have my variables well described
- to have my datasets tidy


This project includes the following files:
=========================================

### run_analysis.R

This script contains the following functions: 

`download_file(remote_filename, desired_filename, dir)`

Helper function to download files with easy to use names to desired directory.

remote_filename  - the url of the file to download
desired_filename - the desired local filename
dir              - the desired directory to download the remote file to


`setnewwd(data_directory)`

Helper function to create and set a working directory if needed.

data_directory - created if data_directory is not in current working directory or current working directory is not data_directory


`run_analysis()`

no parameters needed.

This function runs the analysis desired for the Coursera Data Science - Getting and Cleaning Data final project.

It does the following 5 steps as defined by the project description.

1. Merges the training and the test sets to create one data set.  ( combined_set in the script )
2. Extracts only the measurements on the mean and standard deviation for each measurement. ( combined_set_means_std in the script )
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. (combined_summarized_mean in the script )


### CodeBook.md

This file describes the variables, data, and transformations I did in order to get to the final analysis.

### README.md

This file.  Used as an index to describe the other files.
