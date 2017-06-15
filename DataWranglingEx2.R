#Load Titanic data into a dataframe
data_xls = readxl::read_xls("titanic3.xls")
write.csv(data_xls,file = "titanic_original.csv",row.names = FALSE)
data = read.csv("titanic_original.csv")
library(tidyr)
library(dplyr)

# Replace missing values in embarked colum with "S"
x <- which(is.na(data$embarked))
data$embarked[x] <- "S"


#Calculate mean of age column and use this mean to replace the missings
mean_age <- mean(data$age, na.rm = TRUE)
y <- which(is.na(data$age))
data$age[y] <- mean_age


#Scatterplot to see if there is a relation between siblings and age of the person
#plot(data$sibsp,data$age): not a clear trend

#Think about other ways you could have populated the missing values in the age column.
#Why would you pick any of those over the mean (or not)?
#A: simulate values from empirical distribution by using the calculated mean and std as argument
#Why? Using a fixed age for every passenger is not so realistic while using a varying age is more realistic

#Replace missing values with "NA"
z <- which(is.na(data$boat))
data$boat[z] <- as.character(NA)
#Next line checks structure of boat column after replacing missing values
#str(data$boat)

#You notice that many passengers don’t have a cabin number associated with them.
#Does it make sense to fill missing cabin numbers with a value?
#A: I would not fill missing cabin numbers. It could be that a passenger did not reserve a cabin.
#What does a missing value here mean?
#A: A possible explanation is that the passenger did not reserve a cabin.

#Add new column has_cabin_number 
data <- mutate(data, has_cabin_number=ifelse(is.na(data$cabin),0,1))

#Compute the fraction of survivals with a cabin number and without a cabin number
data %>% 
  group_by(has_cabin_number) %>% 
  summarise_each(funs(mean),survived)
#Here we see that from the people who do have a cabin number 65% survived
#Sanity check: code below should give the same fraction:
#sum(data$survived==1&data$has_cabin_number==1)/sum(data$has_cabin_number==1)

#Write the cleaned file in csv
write.csv(data, "titanic_clean.csv",row.names = FALSE)



