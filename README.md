# Data Analytics Project - LAcrime

## About

Explore my personal project delving into Los Angeles's 2022 crime data. Completed in December 2023, this project includes a [report](https://github.com/ChandlerTinagero/LAcrime/blob/main/README.md#analyze--visualize) that uncovers surprising findings about crime in America's second-largest city. Additionally, the project features an interactive dashboard capable of answering questions such as 'Which LA neighborhoods report the most stolen vehicles?' or 'How are different demographics affected by crime?' Take a peek – it's all right [here](https://github.com/ChandlerTinagero/LAcrime/blob/main/README.md#dashboard)!

__Index:__  
1. [Define the Goal](https://github.com/ChandlerTinagero/LAcrime/edit/main/README.md#define-the-goal)  
2. [Data Collection](https://github.com/ChandlerTinagero/LAcrime/blob/main/README.md#data-collection)  
3. [Data Cleaning](https://github.com/ChandlerTinagero/LAcrime/blob/main/README.md#data-cleaning)  
4. [Analyze / Visualize](https://github.com/ChandlerTinagero/LAcrime/blame/main/README.md#data-collection)  
5. [Report](https://github.com/ChandlerTinagero/LAcrime/blob/main/README.md#analyze--visualize)  
6. [Dashboard](https://github.com/ChandlerTinagero/LAcrime/blob/main/README.md#dashboard)  

## Define The Goal

The goal of this project is first to better understand the overall crime profile in Los Angeles during 2022 by looking at how different variables impact crime. Next, I will answer the following questions:  
1. What are the crime trends from 2021 to 2022? Which types of crime increased or decreased the sharpest?  
2. Did LAPD achieve its goal, as stated in its Strategic Plan 2021-2023, of reducing robbery, aggravated assault, and sexual assault on the Metro by 10% from 2021 to 2022?  
3. How do victim demographics compare to the actual demographics of Los Angeles? Are certain genders, age groups, or races disproportionately the victims of crime?  

## Data Collection  

I will use a dataset titled "[USA, Los Angeles Crimes Data: 2020 To 2023](https://www.kaggle.com/datasets/ishmaelkiptoo/usa-los-angeles-crimes-data-2020-to-2023/data)https://www.kaggle.com/datasets/ishmaelkiptoo/usa-los-angeles-crimes-data-2020-to-2023/data)" from Kaggle to complete the bulk of my analysis. Originally published by the City of Los Angeles, the dataset encompasses individual entries for each crime incident with columns like date and time, victim demographics, location, and more. The dataset includes 21 columns and 847,725 rows in .csv format.   

Additionally, I will use the [2021 Citywide Demographic Profile](https://planning.lacity.org/odocument/491f25dd-7c3f-4f53-984b-35b3038ecd05/standard_report_2021.pdf) by the Department of City Planning, City of Los Angeles. This report contains demographic information about Los Angeles and will be used to better understand victim demographics relative to the area.

## Data Cleaning

I will use R with the lubridate package to clean the LA crime dataset mentioned above. I will highlight a few key points of the data-cleaning process and summarize the cleaned dataset below. The R script with the entire data cleaning process is attached to this repository as crime.R.  

### Loading Packages and Reading in Data  

```
## Loading packages
library(lubridate)

## reading in .csv file
crime <- read.csv("crimedata.csv")
```

### Editing the Time Occurred Column

The first challenge I faced was that the TIME.OCC column was meant to be shown in military time, but the leading zeros were missing.  

![alt text](https://github.com/ChandlerTinagero/LAcrime/blob/main/Images_for_README/Time%20Head.png)  
![alt text](https://github.com/ChandlerTinagero/LAcrime/blob/main/Images_for_README/Time%20Summary.png)

I wrote the following function to convert the times into a more readable format.  
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

Here is what the new time format looks like:  

![alt text](https://github.com/ChandlerTinagero/LAcrime/blob/main/Images_for_README/New%20Time%20Head.png)

### Assigning NA Values for some Victim Ages  

Next, I noticed victims with ages under zero and over 100, for which I assigned an NA value. When I ran a histogram, I found a concentration of crimes where the victim age was zero. This cluster is almost certainly due to "0" being a placeholder for crimes without a human victim. I assigned an NA value for these ages.  

```
summary(crime$Vict.Age) # includes negative ages and ages over 100
crime[crime$Vict.Age<0,] # most negative ages are for crimes against nonpersons e.g. businesses
crime[crime$Vict.Age>100,] # one observation for a 120 year old victim. Clearly a mistake
crime$Vict.Age <- ifelse(crime$Vict.Age > 100 | crime$Vict.Age < 0, NA, crime$Vict.Age) # assigning negative ages and ages and over 100 an NA value
summary(crime$Vict.Age) # verify
hist(crime$Vict.Age, breaks = seq(0,100, by = 1)) # unreasonable amount of victims aged 0 (not yet 1)
crime$Vict.Age[crime$Vict.Age==0] <- NA # assigning victims aged 0 an NA value
```

![alt text](https://github.com/ChandlerTinagero/LAcrime/blob/main/Images_for_README/Age%20Histogram.png) 

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

The primary focus of my analysis is on crimes that occurred during 2022. I'm also interested in crimes from 2021 so that I can see trends and determmine whether LAPD has acheived its goal of decreasing certain crimes by 10% on the Metro. I will filter for data from the beginning of 2021 to the end of 2022 using lubridate's year() function.  

```
crime <- crime[year(crime$Date)==2021 | year(crime$Date)==2022, ] ## Filtering dataframe for crimes that occurred in 2021 and 2022
```

### Summary of Cleaned Dataset  

Before the cleansing process, the dataset contained 21 columns and 847,725 rows. Post-cleansing, the dataset was reduced to nine columns and 443,841 rows. The data cleansing process involved converting variables to their appropriate data type, identifying and replacing inaccurate values with NAs, filtering the dataset within a specific timeframe, introducing new descriptive variables, and various other adjustments. Notably, due to many crimes lacking human victims, columns detailing victim demographics contain a significant volume of NA values.  

Summary of cleaned LA Crime dataset:  
![alt text](https://github.com/ChandlerTinagero/LAcrime/blob/main/Images_for_README/Cleaned%20Dataset%20Summary.png)

## Analyze / Visualize  

Most of the analysis was performed through visualizations in Tableau which will be shown in the report. R was used to extract specific data for the visualizations, and this work is shown below. 

```
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
```


## Report  


## Dashboard   
[dashboard](https://public.tableau.com/views/CrimeinLosAngeles2022/Dashboard?:language=en-US&:display_count=n&:origin=viz_share_link)

![alt text](https://github.com/ChandlerTinagero/LAcrime/blob/main/Images_for_README/Dashboard.png)




