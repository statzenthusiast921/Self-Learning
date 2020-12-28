#Lesson 25: Arrange and Mutate
OT_data=read_excel("OrangeTheoryData.xlsx",sheet=1)

#Filter data
filter=filter(OT_data,Splat<10)
dim(filter)
head(filter)
filter

#Arrange ("Sort") Data
arranged=arrange(filter,Splat)
dim(arranged)
arranged


# Mutate data
arranged %>% mutate(
  splat2=Splat^2,
  calories2=Calories+2
)
dim(arranged)
arranged
#not saved, as mutate only creates new columns in real time


#add columns with mutate by assigning it to new data name
arranged2=arranged %>% mutate(
  splat2=Splat^2,
  calories2=Calories+2
)
dim(arranged2)
arranged2

#Check the change of data type
str(filter)
filter$DaysSince=as.factor(filter$DaysSince)
str(filter)
