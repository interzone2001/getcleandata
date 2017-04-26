library(tidyverse)

# Read in test files
x_test <- read.table('X_test.txt',stringsAsFactors = FALSE)
y_test <- read.table('y_test.txt',stringsAsFactors = FALSE)
# Read in training files
subject_test <- read.table('subject_test.txt',stringsAsFactors = FALSE)
x_train <- read.table('X_train.txt',stringsAsFactors = FALSE)
y_train <- read.table('y_train.txt',stringsAsFactors = FALSE)
subject_train <- read.table('subject_train.txt',stringsAsFactors = FALSE)
# Read in list of variable names to use as header
features<-read.table('features.txt',stringsAsFactors = FALSE)
features <- subset(features,select=V2)  #Just keep the column with the variable names
# transpose rows to columns to use for header
head<-as.character(t(features)) #coerce to character type
# Apply column names to dataset headers
colnames(x_test) <- head
colnames(x_train) <- head
colnames(y_test) <- c('Activity') #more descriptive variable name
colnames(y_train) <- c('Activity')
colnames(subject_test) <- c('Subject')
colnames(subject_train) <-c('Subject')
# Combine x and y datasets
xy_test <- cbind(y_test,x_test)
xy_train <- cbind(y_train,x_train)
# Combine with subject numbers
xy_test <- cbind(subject_test,xy_test)
xy_train <- cbind(subject_train,xy_train)
# Combine training and test datasets
xy_test_train <- rbind(xy_test,xy_train)
#Select for columns with mean() or std()
xy_tt_final<- xy_test_train[ , grep("mean\\(\\)|std\\(\\)|Subject|Activity" , colnames(xy_test_train))]
#Rename Activity values with descriptive label based on activity_labels.txt
xy_tt_final$Activity[xy_tt_final$Activity == 1]<-"Walking"
xy_tt_final$Activity[xy_tt_final$Activity == 2]<-"Walking Upstairs"
xy_tt_final$Activity[xy_tt_final$Activity == 3]<-"Walking Downstairs"
xy_tt_final$Activity[xy_tt_final$Activity == 4]<-"Sitting"
xy_tt_final$Activity[xy_tt_final$Activity == 5]<-"Standing"
xy_tt_final$Activity[xy_tt_final$Activity == 6]<-"Laying"
#Group by Subject and Activity, and then provide an average value for all columns
tidy_df<-xy_tt_final%>%group_by(Subject,Activity)%>%summarize_all(mean)
#write out tidy summary dataframe to file for uploading
write.table(tidy_df,"UCIHAR tidy.txt")
