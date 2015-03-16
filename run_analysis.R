### LOAD THE LIBRARIES
  library("LaF")
  library("ffbase")
  library("data.table")

setwd("Curso Getting and Cleaning Data/Project/UCI HAR Dataset")

### LOAD METADATA (feature and activity labels)
  feature.labels <- read.table("features.txt",sep = " ",header=F,
                               col.names = c("index","feature"))
  activity.labels <- read.table("activity_labels.txt",sep = " ",header=F,
                                col.names = c("index","activity"))

#typeof (X.train[[1]])

### LOAD DATA FILES - The X file column names are taken from "features" metadata. 
###                   Column widths in X files are set to 16
  ### SUBJECTS (subject files)
      subject.test <- read.table("test/subject_test.txt",sep = "",header=F,
                                 col.names = "subject")
      subject.train <- read.table("train/subject_train.txt",sep = "",header=F,
                                  col.names = "subject")
      subject <- rbind(subject.test, subject.train)
  # delete original data and free memory
      rm("subject.test","subject.train")    
      gc()
  
  ### ACTIVITY LABELS (y files)
      y.test <- read.table("test/y_test.txt",sep = "",header=F,
                           col.names = "activity")
      y.train <- read.table("train/y_train.txt",sep = "",header=F,
                            col.names = "activity")
      y <- rbind(y.test, y.train)
  # delete original data and free memory
      rm("y.test","y.train") 
      gc()
  
  ### DATA (X files)
    x.widths <- rep(16,561) # 16 digits width for each column (measurement) in the file
  
    my.data.laf <- laf_open_fwf("test/X_test.txt", 
                                column_names = as.character(feature.labels$feature),
                                column_widths=x.widths,column_types=rep('double',561))
    X.test <- laf_to_ffdf(my.data.laf)
    X.test <- as.data.frame(X.test)
    
    my.data.laf <- laf_open_fwf("train/X_train.txt", 
                                column_names = as.character(feature.labels$feature),
                                column_widths=x.widths,column_types=rep('double',561))
    X.train <- laf_to_ffdf(my.data.laf)
    X.train <- as.data.frame(X.train)
  
    X <- rbind.data.frame(X.test,X.train)
  # delete original data and free memory  
    rm("X.test","X.train")
    gc()

### JOIN DATA
  # Extract all mean and standar deviation variables by name and 
  # add Subjects and Activities columns related to each row
    mean_std <- X[,grep("(mean|Mean|.std)",names(X))]
    mean_std$Subject <- factor(subject$subject)
    mean_std$Activity <- factor(y$activity)
  # Calculate means by Subject and Activity
    tidy <- aggregate(. ~ Subject + Activity, mean_std,mean)
  # Assign descriptive labels to each activity from activity.label metadata
    tidy$Activity <- merge(tidy,activity.labels,
                           by.x="Activity",by.y="index")$activity
  # Copy the result to the file 'tidy.txt'
    write.table(tidy,"tidy.txt",row.name=FALSE)
