# Download your file
# Unzip
# Load into data tables
# Use labels in -./UCI HAR Dataset/activity_labels.txt”  to replace numeric row values in # y_test.txt 
# Create index for y_test.txt
# Check number of rows(observations) for y_test.txt to use in seq command to create an index

y_test_plusIndex <- mutate(y_test.txt,indexy = seq.int(1,nrow(y_test.txt),1))


# Merge activity_labels.txt with y_test_plusIndex

testActivityWithLabels <- merge(activity_labels, y_test_plusIndex, by.x="V1", by.y="V1”)


# Add Subject number: 

subjectTest_plusIndex <- mutate(subject_test, indexTrain=seq.int(1,nrow(y_test.txt),1))


# Use labels in - ./UCI HAR Dataset/activity_labels.txt”  to replace numeric row values in y_train.txt 


# Check number of rows(observations) for y_train.txt to use in seq command to create an index

y_train_plusIndex <- mutate(y_train.txt,indexTrain = seq.int(1,nrow(y_train.txt),1))


# Merge activity_labels.txt with y_test_plusIndex

trainActivityWithLabels <- merge(activity_labels, y_train_plusIndex, by.x="V1", by.y="V1”)


# Add subject number: 

subjectTrain_plusIndex <- mutate(subject_test, indexTrain=seq.int(1,nrow(y_train.txt),1))


# Merge activity with labels with subject: 

trainActivityWithLabelsSub <- merge(trainActivityWithLabels, subjectTrain_plusIndex, by.x="indexTrain", by.y="indexTrain”)


# Add Category for Test or Train

testActivitySubject <- mutate(testActivityWithLabelsSub, Category = "TEST”)

trainActivitySubject <- mutate(trainActivityWithLabelsSub, Category = "TEST”)


# Trim away superfluous columns; RENAME FOR CLARITY:

colnames(testActivitySubject) [1] <- “index”
colnames(testActivitySubject)[3] <- “activity"
colnames(testActivitySubject)[4] <- “subjectID”
colnames(testActivitySubject)[2] <- NULL
colnames(trainActivitySubject) [1] <- “index”
colnames(trainActivitySubject)[3] <- “activity"
colnames(trainActivitySubject)[4] <- “subjectID”
colnames(trainActivitySubject)[2] <- NULL
mutate(testActivitySubject, V1.x = NULL)
mutate(trainActivitySubject, V1.x = NULL)


# Add indexes to Test and Train data sets

X_testIndexed <- mutate(X_test, index = seq.int(1,nrow(y_test.txt),1))

X_trainIndexed <- mutate(X_train, index = seq.int(1,nrow(y_train.txt),1))


# Eliminate the “V” in the variable names for easier matching in next step:

colnames(X_trainIndexed)[1:561] <- sub("V","",names(X_trainIndexed))
colnames(X_testIndexed)[1:561] <- sub("V","",names(X_testIndexed))


# Replace Variable numbers with more descriptive variable names from "features” file
colnames(X_testIndexed) <- features[ ,2]
colnames(X_trainIndexed) <- features[ ,2]

#Add index back in to test: 

colnames(X_testIndexed)[562] <- "index"

#Add index back in to train: 

colnames(X_trainIndexed)[562] <- “index"

# Combine Data sets descriptors and test/train:

trainDataSetComplete <- merge(trainActivitySubject, X_trainIndexed, by.x="index", by.y="index”)

testDataSetComplete <- merge(testActivitySubject, X_testIndexed, by.x="index", by.y="index")

# Combine Data sets: 

EntireDataSetComplete <- unique(rbind(trainDataSetComplete,trainDataSetComplete))

# Select out the Mean and Standard Deviations only: 

EntireDataSetMeanSD <- select(EntireDataSetComplete, index, activity, subjectID, category, contains("mean"), contains("std")) (Q for short)

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject:

# Prepare data for melting by eliminating the index and category columns:

EntireDataSetMeanSDCrop <- mutate(EntireDataSetMeanSD, index=NULL, category=NULL)

# Melt data, separating identifiers v. variables: 

EntireDataSetMeanSDMelt <- melt(EntireDataSetMeanSDCrop, id = c("subjectID", "activity"), measures.vars=c(contains("mean"),c(contains("std"))))

# cast and find mean of data: 

VariableMeanBySubActivity <- dcast(EntireDataSetMeanSDMelt, subjectID + activity ~variable, value.var='value', mean)

# Hooray! We’re done!!!
