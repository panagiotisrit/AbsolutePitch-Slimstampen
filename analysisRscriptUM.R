library(readr)
library(viridis)
library(reshape2)
library(dplyr)
library(ggplot2)


# load all the subject csv into the temp list
temp = list.files(pattern="*.csv")

# iterate over the temp list to get all
# subjects into one dataframe,
# adding a subject number (based on order of file in list: anonymous)

i = 1
data <- data.frame()
for (file in temp){
  temp_subject <- read_csv(file)
  temp_subject$subject <- i
  i = i + 1
  data <- rbind(data,temp_subject)
}

View(data) 


test_data <- filter(data, test == "test")
View(test_data)

# get mean number of correct answers per group
aggregate( correct ~ condition, test_data, mean )


#  anova
resTest.aov <- aov(correct ~ condition, data = test_data)

# Summary of the analysis
summary(resTest.aov)

# test for multiple comparisons, is necessary
TukeyHSD(resTest.aov)


# TODO:
# get the rest of the subjects - basic statistical analysis should work now
# make plots for presentation
# look at reaction time? other conditions? more specific? (only do this for more subjects)
# look at the learning set, how and if learning improves over time?
#     Something with the alpha value or something?

