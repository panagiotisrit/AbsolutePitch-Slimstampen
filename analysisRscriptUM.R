library(readr)
library(viridis)
library(reshape2)
library(dplyr)
library(ggplot2)
library("gridExtra")



# load all the subject csv into the temp list
temp = list.files(pattern="*.csv")

temp
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


# ############## ############## ############## ############## ############## #############

# check if some items are more difficult than others (should analyse separately)
# based on actual starting note (going across the octave).

# from these plots we can see that pitch is terrible, c is slightly more correct?
# instruments are easy
# and tritone + minor second are done easily as well

aggregate( correct ~ answer, test_data, mean)

# filter based on instrument, single note or interval

pitch <- filter(test_data, condition == "pitch_masked" | condition == "pitch_unmasked")
interval <- filter(test_data, condition == "interval_masked" | condition == "interval_unmasked")
instrument <- filter(test_data, condition == "instrument_pitch" | condition == "instrument_interval")

p<-ggplot(data=aggregate( correct ~ answer, pitch, mean), aes(x=answer, y=correct)) +
  geom_bar(stat="identity") + expand_limits(y=c(0, 1))
p1 <- p + coord_flip()

p<-ggplot(data=aggregate( correct ~ answer, interval, mean), aes(x=answer, y=correct)) +
  geom_bar(stat="identity")
p2 <- p + coord_flip()

p<-ggplot(data=aggregate( correct ~ answer, instrument, mean), aes(x=answer, y=correct)) +
  geom_bar(stat="identity")
p3 <- p + coord_flip()

grid.arrange(p1, p2, p3)



########### something with alpha ###########






# TODO:
# get the rest of the subjects - basic statistical analysis should work now
# make plots for presentation
# look at reaction time? other conditions? more specific? (only do this for more subjects)
# look at the learning set, how and if learning improves over time?
#     Something with the alpha value or something?

