#Lesson 55 - ANOVA Project

#1.) Load dosage dataset
library(readxl)
setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
dose=read_excel("dose.xlsx")
dim(dose)
head(dose)
colnames(dose)


#2.) Create a few plots
tableplot(dose)
ggplot(data=dose,aes(y=dose$Score,x=dose$Gender))+geom_boxplot(aes(col=dose$Gender))+labs(title="Boxplot for Scores by Gender")
ggplot(data=dose,aes(y=dose$Score,x=dose$Dose))+geom_boxplot(aes(col=dose$Dose))+labs(title="Boxplot for Scores by Dose")

#3.) One-way ANOVA
shapiro.test(dose$Score)
leveneTest(dose$Score~as.factor(dose$Dose))

doseaov=aov(dose$Score~dose$Dose)
summary(doseaov)

#4.) Post-HOC Test
TukeyHSD(doseaov)
par(mfrow=c(1,1))
plot(TukeyHSD(doseaov),xlim=c(-5,30))

