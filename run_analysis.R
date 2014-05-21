#load the datasets & piece them together
xTrain <- read.table("train/X_train.txt")
yTrain <- read.table("train/y_train.txt")
subjectTrain <- read.table("train/subject_train.txt")
dataTrain <- cbind(xTrain,subjectTrain,yTrain)

xTest <- read.table("test/X_test.txt")
yTest <- read.table("test/y_test.txt")
subjectTest <- read.table("test/subject_test.txt")
dataTest <- cbind(xTest,subjectTest,yTest)

activity <- read.table("activity_labels.txt")
features <- read.table("features.txt")

data <- rbind(dataTest,dataTrain)

#add the column names to the data set
columnNames <- read.table("features.txt")
columnNames <- as.character(columnNames[,2])
columnNames[562] <- "subject"
columnNames[563] <- "activity"
columnNames <- t(columnNames)
names(data) <- columnNames[1,]


# give the activities real / understandable labels
ind <- data$activity %in% 1
data[ind,563]<-"WALKING"
ind <- data$activity %in% 2
data[ind,563]<-"WALKING_UPSTAIRS"
ind <- data$activity %in% 3
data[ind,563]<-"WALKING_DOWNSTAIRS"
ind <- data$activity %in% 4
data[ind,563]<-"SITTING"
ind <- data$activity %in% 5
data[ind,563]<-"STANDING"
ind <- data$activity %in% 6
data[ind,563]<-"LAYING"

#subset the data for only those with mean and std dev.
x <- names(data)
test <- c("mean","Mean","std")
pattern<-paste(test,collapse="|")
rows2keep <- grep(pattern,x)
data<-cbind(data[,rows2keep],data[,562:563])

#create a tidy data set with mean of variables by subject by activity
newdata <- ddply(data,.(subject,activity),numcolwise(mean))

#output tidy data set for use
write.table(newdata,"tidyDataSet.txt",col.names=TRUE)
