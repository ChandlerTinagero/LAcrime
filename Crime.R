## Loading libraries
library(lubridate)

##  reading in csv file and taking a look at each column
crime <- read.csv("LA_Crime_Data.csv")
summary(crime)

#-------------------------------------------------------- DATA CLEANING --------------------------------------------------------

# column by column cleaning
head(crime$DR_NO)
crime <- crime[, -which(names(crime) == "DR_NO")] # REMOVED - not useful

head(crime$DATE.Rptd)
crime <- crime[, -which(names(crime) == "Date.Rptd")] # REMOVED - only concerned with when a crime occurred

head(crime$DATE.OCC)
crime$DATE.OCC <- as.Date(crime$DATE.OCC, format = "%m/%d/%y") # converting string to date
head(crime$DATE.OCC)
summary(crime$DATE.OCC) # verify
colnames(crime)[colnames(crime) == "DATE.OCC"] <- "Date" # renamed

head(crime$TIME.OCC) # time occurred is not in a friendly format
convert_time <- function(int_time) { # creating a function to convert the times to hours
  hour <- int_time %/% 100  # getting the hour
  if (hour == 0) {
    return("12 AM")
  } else if (hour < 12) {
    return(paste(hour, "AM", sep = " "))
  } else if (hour == 12) {
    return(paste(hour, "PM", sep = " "))
  } else {
    hour <- hour - 12  # Convert hour to PM format
    return(paste(hour, "PM", sep = " "))
  }
}
crime$TIME.OCC <- sapply(crime$TIME.OCC, convert_time) # applying the function
crime$TIME.OCC <- as.factor(crime$TIME.OCC) # converting string to factor
summary(crime$TIME.OCC) # verify
remove(convert_time)
colnames(crime)[colnames(crime) == "TIME.OCC"] <- "Time" # renamed

head(crime$AREA)
crime <- crime[, -which(names(crime) == "AREA")] # REMOVED - less descriptive version of AREA.NAME

head(crime$AREA.NAME)
crime$AREA.NAME <- as.factor(crime$AREA.NAME) # converting string to factor
summary(crime$AREA.NAME) # verify
colnames(crime)[colnames(crime) == "AREA.NAME"] <- "Area" # renamed

head(crime$Rpt.Dist.No)
crime <- crime[, -which(names(crime) == "Rpt.Dist.No")] # REMOVED - focusing on AREA.Name

head(crime$Part.1.2)
crime <- crime[, -which(names(crime) == "Part.1.2")] # REMOVED - less descriptive than Crm.Cd.Desc

head(crime$Crm.Cd)
crime <- crime[, -which(names(crime) == "Crm.Cd")] # REMOVED - less descriptive copy of Crm.Cd.Desc

head(crime$Crm.Cd.Desc)
crime$Crm.Cd.Desc <- as.factor(crime$Crm.Cd.Desc) # converting string to factor
summary(crime$Crm.Cd.Desc) # verify
colnames(crime)[colnames(crime) == "Crm.Cd.Desc"] <- "Crime" # renamed

head(crime$Mocodes)
crime <- crime[, -which(names(crime) == "Mocodes")] # REMOVED - not useful

summary(crime$Vict.Age) # includes negative ages and ages over 100
crime[crime$Vict.Age<0,] # most negative ages are for crimes against nonpersons ie. businesses
crime[crime$Vict.Age>100,] # one observation for a 120 year old victim. Clearly a mistake
crime$Vict.Age <- ifelse(crime$Vict.Age > 100 | crime$Vict.Age < 0, NA, crime$Vict.Age) # assigning negative ages and ages and over 100 an NA value
summary(crime$Vict.Age) # verify
hist(crime$Vict.Age, breaks = seq(0,100, by = 1), col = "blue") # unreasonable amount of victims aged 0 (not yet 1)
crime$Vict.Age[crime$Vict.Age==0] <- NA # assigning victims aged 0 an NA value
summary(crime$Vict.Age) # verify
colnames(crime)[colnames(crime) == "Vict.Age"] <- "Vict_Age" # renamed

crime$Vict_Age_Group <- c() # creating a new column for age group variable
crime$Vict_Age_Group[crime$Vict_Age >= 0 & crime$Vict_Age <= 4] <- "0-4"
crime$Vict_Age_Group[crime$Vict_Age >= 5 & crime$Vict_Age <= 9] <- "5-9"
crime$Vict_Age_Group[crime$Vict_Age >= 10 & crime$Vict_Age <= 17] <- "10-17"
crime$Vict_Age_Group[crime$Vict_Age >= 18 & crime$Vict_Age <= 21] <- "18-21"
crime$Vict_Age_Group[crime$Vict_Age >= 22 & crime$Vict_Age <= 34] <- "22-34"
crime$Vict_Age_Group[crime$Vict_Age >= 35 & crime$Vict_Age <= 59] <- "35-59"
crime$Vict_Age_Group[crime$Vict_Age >= 60 & crime$Vict_Age <= 64] <- "60-64"
crime$Vict_Age_Group[crime$Vict_Age >= 65 & crime$Vict_Age <= 74] <- "65-74"
crime$Vict_Age_Group[crime$Vict_Age >= 75] <- ">=75"
crime$Vict_Age_Group <- as.factor(crime$Vict_Age_Group) # converting string to factor
summary(crime$Vict_Age_Group)

head(crime$Vict.Sex)
crime$Vict.Sex <- as.factor(crime$Vict.Sex) # converting string to factor
summary(crime$Vict.Sex) # theres a few other gender options like "X", "H", and "-".
crime$Vict.Sex <- ifelse(crime$Vict.Sex != "M" & crime$Vict.Sex != "F", NA, as.character(crime$Vict.Sex)) # assigning all genders other than M and F a na value 
crime$Vict.Sex <- as.factor(crime$Vict.Sex) # converting back to factor
summary(crime$Vict.Sex) # verify
colnames(crime)[colnames(crime) == "Vict.Sex"] <- "Vict_Sex" # renamed

head(crime$Vict.Descent)
crime$Vict.Descent[crime$Vict.Descent == "A" |   # Other Asian
                     crime$Vict.Descent == "C" | # Chinese
                     crime$Vict.Descent == "D" | # Cambodian
                     crime$Vict.Descent == "F" | # Filipino
                     crime$Vict.Descent == "J" | # Japanese
                     crime$Vict.Descent == "K" | # Korean
                     crime$Vict.Descent == "L" | # Laotian
                     crime$Vict.Descent == "V" | # Vietnamese
                     crime$Vict.Descent == "Z"   # Asian Indian
                                               ] <- "Asian"
crime$Vict.Descent[crime$Vict.Descent == "B"] <- "Black"
crime$Vict.Descent[crime$Vict.Descent == "G" |   # Guamanian 
                     crime$Vict.Descent == "I" | # American Indian/Alaskan Native
                     crime$Vict.Descent == "P" | # Pacific Islander
                     crime$Vict.Descent == "S" | # Samoan
                     crime$Vict.Descent == "U"   # Hawaiian
                                               ] <- "Native/Islander"
crime$Vict.Descent[crime$Vict.Descent == "H"] <- "Hispanic"
crime$Vict.Descent[crime$Vict.Descent == "W"] <- "White"
crime$Vict.Descent <- as.factor(crime$Vict.Descent) # converting string to factor
summary(crime$Vict.Descent) 
crime$Vict.Descent <- ifelse(crime$Vict.Descent != "Asian" & 
                               crime$Vict.Descent != "Black" &
                               crime$Vict.Descent != "Native/Islander" &
                               crime$Vict.Descent != "Hispanic" &
                               crime$Vict.Descent != "White" ,
                               NA, as.character(crime$Vict.Descent))
crime$Vict.Descent <- as.factor(crime$Vict.Descent) # converting back to factor
summary(crime$Vict.Descent) # verify
colnames(crime)[colnames(crime) == "Vict.Descent"] <- "Vict_Race" # renamed

head(crime$Weapon.Used.Cd)
crime <- crime[, -which(names(crime) == "Weapon.Used.Cd")] # REMOVED - not useful

head(crime$Weapon.Desc)
crime <- crime[, -which(names(crime) == "Weapon.Desc")] # REMOVED - not useful

# Premises variables will be used to determine whether a crime took place on metro property.
# I will work in excel to see which premises codes and descriptions are metro-related.
# I will then add a column that labels whether a crime took place on metro property.

crime$Metro <- ifelse(
  crime$Premis.Cd %in% c(135, 801, 809, 835:976), # these are the premises codes with metro-related premises descriptions
  "Yes",
  "No"
)
crime$Metro <- as.factor(crime$Metro)
summary(crime$Metro) # verify

crime <- crime[,-c(8:19)] # REMOVED - not useful

crime <- crime[year(crime$Date)==2021 | year(crime$Date)==2022, ] # Filtering dataframe for crimes that occurred in 2021 and 2022
crime21 <- crime[year(crime$Date)==2021, ] # Filtering dataframe for crimes that occurred in 2021
crime22 <- crime[year(crime$Date)==2022, ] # Filtering dataframe for crimes that occurred in 2022

# -------------------------------------------------------- ANALYSIS --------------------------------------------------------

# Creating a table with the average crime count by day of the month. Will visualize in Tableau.
date_crimecount <- aggregate(Crime ~ Date, data = crime22, FUN = length)
day_crimecount <- aggregate(Crime ~ day(Date), data = date_crimecount, FUN = mean)
day_crimecount
write.csv(day_crimecount, file = "crime22avgday.csv", row.names = FALSE)
remove(date_crimecount)
remove(day_crimecount)

# Creating a table with the crime count by victim age group. Will add values from the 2021 Citywide Demographic Profile in Excel and visualize in Tableau.
crime_count_by_age_group22 <- aggregate(Date ~ Vict_Age_Group, data = crime22, FUN = length)
write.csv(crime_count_by_age_group22, file = "crimecountbyagegroup22.csv", row.names = FALSE)
remove(crime_count_by_age_group22)

# Creating a table with the crime count by victim race. Will add values from the 2021 Citywide Demographic Profile in Excel and visualize in Tableau.
crime_count_by_race22 <- aggregate(Date ~ Vict_Race, data = crime22, FUN = length)
write.csv(crime_count_by_race22, file = "crimecountbyrace22.csv", row.names = FALSE)
remove(crime_count_by_race22)












