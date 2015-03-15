================================================
Getting and Cleaning Data R Project
Version 1.0
================================================
Ignacio Herreros Hódar
nachopol@gmail.com
================================================

This project use the data of 'Human Activity Recognition Using Smartphones Dataset'.

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The description of the assignment can be found in the following link:

https://class.coursera.org/getdata-012/human_grading/view/courses/973499/assessments/3/submissions

Current project includes the file 'run_analysis.R' which perform the mean calculation of al the mean and standard deviation features/measurements of merge 
of the X files (X_test and X_train). 

The process is performed in the following steps:

	- Load of the metadata included in features.txt, activity_labels.txt.
	- Load of the subject and activity information of the test and training sets. They are merged in single subject and activity datasets.
	- Load of the test and training sets and merged in a single dataset.
	- Extract the mean and standard deviation measurements from the joined data.
	- Calculation of the mean of each measurement grouped by each Subject and Activity. The result is loaded in a 'mean_std' dataset.
	- Export of the 'mean_std' to a file 'tidy.txt'. First two columns of this file are Subject and Activity.
