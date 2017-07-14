# datacleaningproject
Project for coursera course on data cleaning
============================================

We use dplyr library for preparing the data for analysis
Assumption: current working directory to be the parent directory
of train and test directories

First the script loads train data into trainxdf, trainactdf, trainsubjdf
respectively from X_train.txt, y_train.txt, subject_train.txt in train 
directory.

Then it loads test data set into testxdf, testactdf, testsubjdf
respectively from X_test.txt, y_test.txt, subject_test.txt in test directory.

Then it merges trainxdf and testxdf into one data frame fulldf and removes the
consituent data frames trainxdf and testxdf. Similarly, it merges trainactdf 
and testactdf into fullactdf, and merges trainsubjdf and testsubjdf into 
fullsubjdf. It names the only columns of fullactdf and fullsubjdf to "activity"
and "subject" respectively.

Then it reads the column names from feature.txt, along with serial numbers in 
a data frame named columndf. At first it replaces ',', '(', ')' by '_' in 2nd 
column of columndf, which contains the column names. Then it uses this 2nd 
column of columndf as column names of fulldf

Then the script checks for columns with duplicated names and removes such 
columns. Then it selects only the columns computing mean() or std() of various
measurements. Also, we ignore column names on angular measurements.

Then it adds fullactdf and fullsubjdf before all columns of fulldf. And it 
puts back "()" replacing __ in colnames, changes activity and subject columns 
to factor variables. Now, activity column has 6 labels: "walking", 
"walking_upstairs", "waling_downstairs", "sitting", "standing", "laying". And
the subject column now has 30 possible values 1:30, one for each person

Finally the script creates a new data frame summarydf that will contain average
of each column of measurement in fulldf, grouped by subject and activity.
