library(dplyr)
#Assuming current working directory to be the parent directory
#of train and test directories

#load train data into trainxdf, trainactdf, trainsubjdf
trainxdf <- read.table("train/X_train.txt")
trainactdf <- read.table("train/y_train.txt")
trainsubjdf <- read.table("train/subject_train.txt")

#load test data set into testxdf, testactdf, testsubjdf
testxdf <- read.table("test/X_test.txt")
testactdf <- read.table("test/y_test.txt")
testsubjdf <- read.table("test/subject_test.txt")

#merge trainxdf and testxdf into one data frame fulldf
fulldf <- rbind(trainxdf, testxdf)
rm(trainxdf)
rm(testxdf)

#similarly, merge trainactdf and testactdf into fullactdf
#and merge trainsubjdf and testsubjdf into fullsubjdf
fullactdf <- rbind(trainactdf, testactdf)
fullsubjdf <- rbind(trainsubjdf, testsubjdf)
rm(trainactdf)
rm(testactdf)
rm(trainsubjdf)
rm(testsubjdf)
names(fullactdf) <- c("activity")
names(fullsubjdf) <- c("subject")

#read column names from features.txt
colnamedf <- read.table("features.txt")
#replace ',', '(', ')' by '_' in 2nd column of columndf
colnamedf <- colnamedf %>% mutate(V2 = gsub("[),(]", "_", V2))

#set column names of fulldf from colnamedf
names(fulldf) <- colnamedf$V2

#check for columns with duplicated names; matches() fails on them
names(fulldf)[duplicated(names(fulldf))]
#remove columns with duplicated names; all with bandsEnergy()
fulldf <- fulldf[, !duplicated(names(fulldf))]

dim(fulldf)

#select only the columns computing mean() or std()
#ignore column names starting with angle
fulldf <- select(fulldf, matches("^[^angle].*(mean|std)[_]{2}"))

#add fullactdf and fullsubjdf before all columns of fulldf
fulldf <- cbind(fullactdf, fullsubjdf, fulldf)
rm(fullactdf)
rm(fullsubjdf)
  
#put back "()" replacing __ in colnames
names(fulldf) <- gsub("__", "()", names(fulldf))

#change activity and subject columns to factor
#activity column will have 6 labels: "walking" etc.
#subject column will have 30 possible values 1:30, one for each person
fulldf <- fulldf %>% 
  mutate(activity = factor(activity, 
                           labels = c("walking", 
                                      "walking_upstairs",
                                      "waling_downstairs",
                                      "sitting",
                                      "standing",
                                      "laying"), 
                           ordered = TRUE)) %>%
  mutate(subject = factor(subject))

#create new data frame summarydf that will contain average of each
#column in fulldf, grouped by subject and activity
summarydf <- aggregate(. ~ subject + activity, fulldf, mean)
