# Data Analytics Project - LAcrime
## General Overview
In this project, I analyze crime in Los Angeles for 2022-2023. This project is entirely my own and follows the following framework:

Define the Goal\
Data Collection\
Data Cleaning and Processing\
Analyze / Visualize\
Report\
Dashboard\
\
## Define The Goal
The goal of this project is first to get a better understanding of the overall crime profile in Los Angeles for 2022-2023. I will look for figures like the total number of crimes reported, the most common crimes, and other descriptive values. Next, I will answer the following series of questions\
1. Did LAPD achieve its goal, as stated in its Strategic Plan 2021-2023, of reducing robbery, aggravated assault, and sexual assault on the Metro by 5% from 2021 to 2022?/
2. What are the crime trends? Which crimes increased or decreased the most from 2021 to 2022 and throughout 2022?/
3. How do victim demographics compare to the actual demographics of Los Angeles? Are certain genders, age groups, or races disproportionately the victims of crime? If so, which crimes?/
\



## Data Collection
I will use a dataset titled "[USA, Los Angeles Crimes Data: 2020 To 2023](https://website-name.com](https://www.kaggle.com/datasets/ishmaelkiptoo/usa-los-angeles-crimes-data-2020-to-2023/data)https://www.kaggle.com/datasets/ishmaelkiptoo/usa-los-angeles-crimes-data-2020-to-2023/data)" from Kaggle to complete the bulk of my analysis. This dataset, originally published by the City of Los Angeles, encompasses individual entries for each crime incident with variables like date and time, victim demographics, location, and more. There are 21 columns and 847,725 rows in this dataset, and it is a .csv file.

Additionally, I will use the [2021 Citywide Demographic Profile](https://planning.lacity.org/odocument/491f25dd-7c3f-4f53-984b-35b3038ecd05/standard_report_2021.pdf) by the Department of City Planning, City of Los Angeles. This report contains demographic information about Los Angeles and will be used to better understand victim demographics relative to the area.
\
## Data Cleaning
I will use R with the lubridate package to clean the LA crime dataset mentioned above.
```ruby
## Loading libraries
library(lubridate)

##  reading in .csv file
crime <- read.csv("crimedata.csv")
```

### Code

## Analyze / Visualize


## Report


## Dashboard 
