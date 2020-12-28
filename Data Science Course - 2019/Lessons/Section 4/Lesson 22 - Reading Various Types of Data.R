#Lesson 22: Reading Various Types of Data

#1. Reading CSV files with R
read.csv()

#read.csv2 is used in countries that use a comma as a decimal point and
#a semicolon as a field separator
read.csv2()
#additional function - for reading csv and other formats like copy paste
#data.table package
#separator is automatically recognized
fread()

#2. Reading xls files with R
install.packages("xlsx")
library(xlsx)
read.xlsx()

#3. Reading txt files with R
read.delim()
#read.table is similar to .csv and can be used to read csv files
read.table()

#4. Read XML
install.packages("XML")
library(XML)
xmlParse()

#Read JSON
install.packages("rjson")
library(rjson)
fromJSON()

#foreign package to read octave, SAS, SPSS, and other formats
install.packages("foreign")
library(foreign)
