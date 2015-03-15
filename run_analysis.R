gc(TRUE)
#library("data.table")
#library("sqldf")

### INSTALLATION AND LOAD OF THE LIBRARIES
  install.packages("LaF","ffbase","data.table")
  library("LaF")
  library("ffbase")
  library("data.table")

setwd("/Ignacio/Curso Getting and Cleaning Data/Project/UCI HAR Dataset")

### LOADING METADATA
  #features <- fread("features.txt",sep = "\n") # this one fails because no \n in last line
  feature.labels <- read.table(file = "features.txt",sep = " ")
  activity.labels <- fread("activity_labels.txt",sep = " ",header=F)

  subject.test <- fread("test/subject_test.txt",sep = "\n")
  subject.train <- fread("train/subject_train.txt",sep = "\n")
  subject <- rbind(subject.test, subject.train)
  rm("subject.test","subject.train")

#typeof (X.train[[1]])

### LOADING DATA FILES - The column names are taken from "features" metadata. 
###                      Column widths are set to 16
  #x.widths <- seq(from=16,by=16,length.out=561)
  #typeof(as.character(features$V2))
  ### DATA (X)
    x.widths <- rep(16,561)
    my.data.laf <- laf_open_fwf("test/X_test.txt", 
                                column_names = as.character(feature.labels$V2),
                                column_widths=x.widths,column_types=rep('double',561))
    X.test <- laf_to_ffdf(my.data.laf)
    X.test <- as.data.frame(X.test)
    
    my.data.laf <- laf_open_fwf("train/X_train.txt", 
                                column_names = as.character(feature.labels$V2),
                                column_widths=x.widths,column_types=rep('double',561))
    X.train <- laf_to_ffdf(my.data.laf)
    X.train <- as.data.frame(X.train)
  
    X <- rbind.data.frame(X.test,X.train)
    rm("X.test","X.train")

  ### ACTIVITY LABELS (y)
    y.test <- fread("test/y_test.txt",sep = "\n")
    y.train <- fread("train/y_train.txt",sep = "\n")
    y <- rbind(y.test, y.train)
    rm("y.test","y.train")

### JOIN DATA
    #y2 <- merge(y,activity.labels,by="V1",sort=TRUE)
    #X$Subject <- list(subject$V1)
    #X$activity <- y
    #typeof(y$V1)
    mean_std <- X[,grep("(mean|Mean|.std)",names(X))]
    mean_std$Subject <- factor(subject$V1)
    mean_std$Activity <- factor(y$V1)
    out <- aggregate(. ~ Subject + Activity, mean_std,mean)
    out$Activity <- merge(out,activity.labels,by.x="Activity",by.y="V1")$V2
    write.table(out,"tidy.txt",row.name=FALSE)
#     out <- aggregate(mean_std,subject,mean)
#     mean_std <- data.table(mean_std)
#    out <- mean_std[,lapply(.SD,mean),by=c("Subject","Activity")]
#dim(out)
#     out <- by(mean_std,mean_std$Subject,mean)
#     sapply(mean_std,mean)
#     s <- matrix(rep(subject$V1,ncol(mean_std)),nrow=nrow(subject),ncol=ncol(mean_std))
#     dim(s)
#     dim(mean_std)
#     out <- by(mean_std,s,mean)
#     out <- tapply(mean_std,s,mean)
# warnings()
# merge(subject,activities,by = "V1")
#X.test <- read.fwf(file = "test/X_test.txt",width=x.widths, n = 4)
#X.train <- read.fwf(file = "train/X_train.txt",width=x.widths)
#typeof(X.test$V1[1])

#X.test <- fread("test/X_test.txt",sep="\n",header = FALSE)
#X.train <- fread("train/X_train.txt",sep="\n",header = FALSE)

#X.start.strings <- seq(from=1,by=16,length.out=561)
#X.last.strings <- seq(from=16,by=16,length.out=561)
#temp <- X.test$V1
#X.test.splitted <- sapply(X.test$V1, 
#                          function(x){substring(x,X.start.strings,X.last.strings)})
#x <- substring(X.train$V1[1],X.start.strings,X.last.strings)
#x <- substring(X.train$V1[1],0,16)
#a<-X.test$V1
#a[2]
#n=16
#sapply(seq(1,nchar(a),by=n), function(x) substr(a, x, x+n-1))

#(object.size(X.test)*7352/4)/1024^2
#object.size(X.test[1,1])*561*7352/1024/1024


#ftest <- file("test/X_test.txt")
#ftrain <- file("train/X_train.txt")
#a <- sqldf ("select * from (select * from ftest union select * from ftrain) T limit 1",file.format=list(header=FALSE))
#b <- read.csv.sql("test/X_test.txt",header = FALSE,sql = "select * from file limit 1")
#rm("X.train")
