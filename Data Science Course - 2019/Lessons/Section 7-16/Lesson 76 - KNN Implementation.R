#Lesson 76 - KNN Implementation

setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
glass=read.delim("glass.data",sep=",")
colnames(glass)=c(
  "ID",
  "RI",
  "NA.Sodium",
  "Magnesium",
  "Aluminum",
  "Silicon",
  "Potassium",
  "Calcium",
  "Barium",
  "Iron",
  "Type.glass"
)
View(glass)
str(glass)
summary(glass)

sum(is.na(glass))
dim(glass)


#Exploratory Graphs
glass$Type.glass=as.factor(glass$Type.glass)
ggplot(data=glass.data,aes(y=glass.data$Silicon,x=as.factor(glass.data$Type.glass)))+geom_boxplot(aes(col=as.factor(glass$Type.glass)))
ggplot(data=glass.data,aes(y=glass.data$Magnesium,x=as.factor(glass.data$Type.glass)))+geom_boxplot(aes(col=as.factor(glass$Type.glass)))
ggplot(data=glass.data,aes(y=glass.data$Aluminum,x=as.factor(glass.data$Type.glass)))+geom_boxplot(aes(col=as.factor(glass$Type.glass)))

# Break data up into training and test datasets
set.seed(100)
glass$random=runif(nrow(glass),0,1)
trainingdata=glass[which(glass$random<=0.8),]
testdata=glass[which(glass$random>0.8),]
c(nrow(trainingdata),nrow(testdata))

#Standardize datasets
normalize=function(x){
  return((x-min(x))/(max(x)-min(x)))
}

train.norm=as.data.frame(lapply(trainingdata[,-11],normalize))
test.norm=as.data.frame(lapply(testdata[,-11],normalize))


#lapply applies function to all columns/all rows
View(train.norm)
View(test.norm)
dim(train.norm)
dim(test.norm)
head(train.norm)
head(test.norm)
#Need to create an object for target variable outside of normalized train/test sets
#just works better for the way the function is configurated
str(trainingdata)
output=trainingdata$Type.glass
test.output=testdata$Type.glass


#Let's do the KNN algorithm
library(class)
model1=knn(train=train.norm,test=test.norm,cl=output,k=16)
summary(model1)

#Check accuracy of model
k16=100*sum(test.output==model1)/NROW(test.output)
k16
#78%

table(model1,testdata[,11])

library(caret)
install.packages("e1071")
library(e1071)

confusionMatrix(table(model1,test.output))

length(model1)
length(test.output)
length(output)

model2=knn(train=train.norm,test=test.norm,cl=output,k=3)
k3=100*sum(test.output==model2)/NROW(test.output)
k3
model1

confusionMatrix(table(model2,trainingdata[,11]))
sum(test.output==model1)/100

table(model2,testdata[,11])
plot(model1)
