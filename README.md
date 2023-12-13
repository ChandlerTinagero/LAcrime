# Data Analytics Project - LAcrime

## About

In this project, I analyze crime in Los Angeles for 2022-2023 using R and Tableau. 

This project follows the following framework:  

[Define the Goal](https://github.com/ChandlerTinagero/LAcrime/edit/main/README.md#define-the-goal)  
Data Collection  
Data Cleaning and Processing  
Analyze / Visualize  
Report  
Dashboard  

## Define The Goal

The goal of this project is first to better understand the overall crime profile in Los Angeles for 2022-2023 by looking at how different variables like time of day and geographic area impact crime . Next, I will get more specific by answering the following questions:  
1. What are the crime trends from 2021 to 2022? Which types of crime increased or decreased the sharpest?  
2. Did LAPD achieve its goal, as stated in its Strategic Plan 2021-2023, of reducing robbery, aggravated assault, and sexual assault on the Metro by 5% from 2021 to 2022?  
3. How do victim demographics compare to the actual demographics of Los Angeles? Are certain genders, age groups, or races disproportionately the victims of crime?  

## Data Collection  

I will use a dataset titled "[USA, Los Angeles Crimes Data: 2020 To 2023](https://website-name.com](https://www.kaggle.com/datasets/ishmaelkiptoo/usa-los-angeles-crimes-data-2020-to-2023/data)https://www.kaggle.com/datasets/ishmaelkiptoo/usa-los-angeles-crimes-data-2020-to-2023/data)" from Kaggle to complete the bulk of my analysis. This dataset, originally published by the City of Los Angeles, encompasses individual entries for each crime incident with columns like date and time, victim demographics, location, and more. There are 21 columns and 847,725 rows in this dataset, and it is a .csv file.  

Additionally, I will use the [2021 Citywide Demographic Profile](https://planning.lacity.org/odocument/491f25dd-7c3f-4f53-984b-35b3038ecd05/standard_report_2021.pdf) by the Department of City Planning, City of Los Angeles. This report contains demographic information about Los Angeles and will be used to better understand victim demographics relative to the area.  

## Data Cleaning  

I will use R with the lubridate package to clean the LA crime dataset mentioned above. I will highlight a few key points of the data-cleaning process and summarize the cleaned dataset below. The R script with the entire data cleaning process is attached to this repository as crime.R.  

### Loading in Packages and Data  

```
## Loading libraries
library(lubridate)

## reading in .csv file
crime <- read.csv("crimedata.csv")
```

### Editing the Time Occurred Column

The first challenge I faced was that the TIME.OCC column was meant to be shown in military time, but the leading zeros were missing.  

![alt text](https://github.com/ChandlerTinagero/LAcrime/blob/main/Time%20Head.png)\
![alt text](https://github.com/ChandlerTinagero/LAcrime/blob/main/Time%20Summary.png)

I used the following function to convert the times to a more readable format.  
```
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
```

### Assigning NA Values for some Victim Ages  

Next, I noticed there were victims aged under zero and over 100, for which I assigned an NA value. When I ran a histogram, I found a concentration of crimes where the victim age was zero. I assigned these ages an NA value.  

```
summary(crime$Vict.Age) # includes negative ages and ages over 100
crime[crime$Vict.Age<0,] # most negative ages are for crimes against nonpersons ie. businesses
crime[crime$Vict.Age>100,] # one observation for a 120 year old victim. Clearly a mistake
crime$Vict.Age <- ifelse(crime$Vict.Age > 100 | crime$Vict.Age < 0, NA, crime$Vict.Age) # assigning negative ages and ages and over 100 an NA value
summary(crime$Vict.Age) # verify
hist(crime$Vict.Age, breaks = seq(0,100, by = 1)) # unreasonable amount of victims aged 0 (not yet 1)
crime$Vict.Age[crime$Vict.Age==0] <- NA # assigning victims aged 0 an NA value
```

![alt text](https://github.com/ChandlerTinagero/LAcrime/blob/main/age%20histogram.png)  

### Creating a New Column to Indicate Whether a Crime Occurred on the Metro  

The premises columns (codes and descriptions) indicate where a crime occurred. I worked in Excel to find the codes with metro-related descriptions, which I then used to create a new column indicating whether a crime occurred on the metro.

```
crime$Metro <- ifelse(
  crime$Premis.Cd %in% c(135, 801, 809, 835:976), # these are the premises codes with metro-related premises descriptions
  "Yes",
  "No"
)
crime$Metro <- as.factor(crime$Metro)
summary(crime$Metro) # verify
```

### Filtering for Crimes that Occurred in 2021 and 2022  

The primary focus of my analysis is on crimes that occurred from 2022-2023. I'm also interested in crimes from 2021 so that I can see trends and determmine whether LAPD has reached its goal of decreasing certain crimes by 5% on the Metro. I will filter for data from the beginning of 2021 to the end of 2022 using lubridate's year() function.  

```
crime <- crime[year(crime$Date)==2021 | year(crime$Date)==2022, ] ## Filtering dataframe for crimes that occurred in 2021 and 2022
```

### Summary of Cleaned Dataset  

Before the cleansing process, the dataset contained 21 columns and 847,725 rows. Post-cleansing, the dataset was reduced to nine columns and 443,841 rows. The data cleansing process involved converting variables to their appropriate data type, identifying and replacing inaccurate values with NAs, filtering the dataset within a specific timeframe, introducing new descriptive variables, and various other adjustments. Notably, due to many crimes lacking human victims, columns detailing victim demographics contain a significant volume of NA values.  

Summary of cleaned LA Crime dataset:  
![alt text](https://github.com/ChandlerTinagero/LAcrime/blob/main/summary%20of%20cleaned%20dataset.png)

## Analyze / Visualize  



## Report  


## Dashboard   
