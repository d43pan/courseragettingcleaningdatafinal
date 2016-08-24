library(dplyr)
library(tidyr)
library(lubridate)

data_dir <- "data"

## download_file is a helper function to set the directory
## at the script level instead of at the call level.  
## This allows for consistency across all downloads.

download_file <- function(remote_filename, desired_filename, dir){
  file_url <- remote_filename
  download.file(file_url, destfile = desired_filename, method="curl")
  list.files( paste0("./",dir) )
}


## setnewwd is a helper function to handle the common task of finding 
## and creating a working directory as needed.
## 
## It will check to see if the directory your looking for already exists.
## It will check to see if you're in a directory with the same name
## It assumes you want to make a new working directory if neither of the above conditions are met
##
## Note - this function sets the working directory for all calls going forward.
##
##


setnewwd <- function(data_directory){
  if(!file.exists(data_directory) && basename(getwd()) != data_directory){
    dir.create(data_directory)
    setwd(data_directory)
  }
}

run_analysis <- function(){
  
  # 0 Setup
  # First few steps are all about getting the data (before actually running the data).
  
  # Set the working directoy to a data directory in the current directory
  setnewwd(data_dir)

  
  # Set the files to download and the desired name
  file_urls  <- c( "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  )
  file_names <- c( "ucihar.zip")
  
  for( f in seq_along(file_urls) ){
    if( !file.exists(file_names[f])){
      download_file(file_urls[f], file_names[f], data_dir)
    }
  }

  # unzip the archive from the download path
  unzip("ucihar.zip")
  
  
  # 1. Merge training and test sets to create one dataset
  
  # merge subject, activity, and observation data together
  # rename subject and activity sets so there's no conflict on bind_cols
  
  training_set_subject <- tbl_df(read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE))
  training_set_activity <- tbl_df( read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE))
  training_set_observations <- tbl_df( read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE, strip.white = TRUE))
  names(training_set_subject)[1] <- c("subject")
  names(training_set_activity)[1] <- c("activity")
  
  training_set <- bind_cols( training_set_subject, training_set_activity, training_set_observations)
  
  test_set_subject <- tbl_df(read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE))
  test_set_activity <- tbl_df( read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE))
  test_set_observations <- tbl_df( read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE, strip.white = TRUE))
  names(test_set_subject)[1] <- c("subject")
  names(test_set_activity)[1] <- c("activity")
  
  test_set <- bind_cols( test_set_subject, test_set_activity, test_set_observations)
  
  # Combine training and test sets to create one dataset

  combined_set <- bind_rows(training_set, test_set)
  
  # 2. Extract only the measurements on the mean and standard deviation for each measurement
  
  # Get the features labels vector which will end up as the column headers
  features <- tbl_df( read.table("UCI HAR Dataset/features.txt") )
  
  # Correct indices for fact that subject and activity will be added to the front.
  features <- mutate(features,  V1 = V1 + 2) 
                                              
  # Add subject and activities rows to features labels vector
  subject_row <-    data.frame( V1 = 1, V2 = "subject") 
  activities_row <-  data.frame( V1 = 2, V2 = "activity") 
  
  features <- bind_rows(features, subject_row, activities_row)
  
  # arrange features by row number 
  features <- arrange(features, V1)
  
  # Subset of rows from features which are just the mean(), std()  
  # (bring along activity and subject).  
  features_means_std <- subset( features, grepl("((activity|subject)|(mean|std)\\(\\))", V2) )
  
  # Subset of columns from merged_set which only include the mean and std columns 
  # (bringing along activity and subject)
  combined_set_means_std <- select( combined_set, features_means_std$V1 )
  
  
  # 3. Use descriptive activity names to name the activities in the data set
  activity_labels <- tbl_df( read.table("UCI HAR Dataset/activity_labels.txt"))
  
  # Description of what's going on in the following single line.
  # with(data, expression)
  #   data       - Create an environment with the activity_labels provided in the dataset
  #   expression - set the value to text label for activity by the numeric value provided in the observations
  #        match(x, table) 
  #             x     - in this environment is the particular numeric value for activity provided in observations
  #             table - activity_labels provided to match against
  combined_set_means_std$activity <- with(activity_labels, V2[match(combined_set_means_std$activity, V1)])
  
  # 4. Appropriately label the data set with descriptive variable names.
  
  # Using the labels from the features.txt as a starting point.
  # I will take the following steps
  #  
  #  replace beginning 't' with 'time-' and 'f' with 'frequency-'
  #  replace 'Mag' with 'magnitude'
  #  reaplce 'Acc' with 'acceleration'
  #  remove the parentheses
  #  remove dashes
  #  replace "BodyBody" with "Body" in the mis labeled variables from the original data
  #  lowercase variable names
  descriptive_var_names <- features_means_std
  
  descriptive_var_names$V2 <- gsub('^[f]', 'frequency-', descriptive_var_names$V2)
  descriptive_var_names$V2 <- gsub('^[t]', 'time-', descriptive_var_names$V2)
  descriptive_var_names$V2 <- gsub('Mag', 'magnitude', descriptive_var_names$V2)
  descriptive_var_names$V2 <- gsub('Acc', 'acceleration', descriptive_var_names$V2)
  descriptive_var_names$V2 <- gsub('\\(\\)', '', descriptive_var_names$V2)
  descriptive_var_names$V2 <- gsub('BodyBody', 'Body', descriptive_var_names$V2)
  descriptive_var_names$V2 <- tolower(descriptive_var_names$V2)
  
  # I believe they are accurate descriptions, easy to read, and informative as to their meaning.
  names(combined_set_means_std) <- descriptive_var_names$V2
  
  # 5 From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
  # grouping by activity and then subject 
  combined_summarized_mean <- combined_set_means_std %>% 
    group_by( activity, subject ) %>%
    summarize_each(funs(mean))
  
  write.table(combined_summarized_mean, file="tidy_data.txt", row.names = FALSE)
  
  # This is a convenience list for returning each of the pieces of information I created along the way.
  # Used for testing and validation at each step
  vars <- list( 
                test_set = test_set,
                combined_set = combined_set, 
                combined_set_means_std = combined_set_means_std, 
                features = features, 
                features_means_std = features_means_std,
                descriptive_var_names = descriptive_var_names,
                activity_labels = activity_labels, 
                combined_summarized_mean = combined_summarized_mean)
  #vars
  
  invisible(combined_summarized_mean)
}



get_tidy_data <- function(){
  tidy_data <- read.table("tidy_data.txt")
  tidy_data
}