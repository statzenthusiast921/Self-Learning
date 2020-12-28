#Lesson 23: Data Selection and Manipulation

#Common Functions
#1.) Use $ sign to select variables
#2.) Use [row, column] to select rows and columns
#3.) Use dataframe$columnname=as.numeric/factor(dataframe$columnname)
#    to update a column/variable

#4.) Use merge(x,y,...) to join 2 or more datasets
#5.) Use with() function to simplify calculations:
#    a.) This:
#        a=mean(data$col1 + data$col2 + data$col3)
#        Becomes
#    b.) This:
#        a=with(data, mean(col1,col2,col3))

#6. Use the dplyr function to:
#   a.) select: return a subset of columns of a data frame
#   b.) filter: extract a subset of rows from a data frame 
#       based on logical conditions
#   c.) arrange: reorder rows of data frame
#   d.) rename: rename variables in data frame
#   e.) mutate: add new variables or transform exisiting variables
#   f.) summarize: generate summary stats of different variables in data frame

#7. Use the Tidyr package
#   a.) library(tidyr)
#   b.) Gather() - takes multiple columns, and gathers them into
#       key value pairs - makes "wide" data longer
#   c.) Spread() - takes two columns (key & value) and spreads in to 
#       multiple columns - makes "long" data wider
#   d.) Separate() - Given either regular expression or a vector of 
#       character positions, turns a single character column into
#       multiple columns
#   e.) Extract() - Given a regular expression with capturing groups, it
#       turns each group into a new column.  If the groups don't match,
#       or the input is NA, the output will be NA.

#8. Use the lubridate package: used to handle dates like time zones and
#   calculations related to time
#
#   Example: x=interval(ymd("2018-01-01"),ymd("2018-09-18"))
#            as.duration(x)
#   [1]      "22464000s (~37.14 weeks)"