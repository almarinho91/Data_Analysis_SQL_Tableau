# Cyclistic Bike-Sharing: Data Analysis Case Study
In this data analysis case study, the bike-sharing fictional company Cyclistic wants to answer some important questions for the further development of the company through its rides database. The data used corresponds to the period from August 2021 to July 2022 and can be found [here](https://divvy-tripdata.s3.amazonaws.com/index.html). The public data are provided and licensed by Motivate International Inc. through 12 zipped .csv files. The objectives of this project are to do a data analysis to answer some questions about the company. For this were used:

- Excel and SQL Server for initial analysis;
- Data processing (cleaning, validation and exploration) through SQL queries (code documentation available in this repository);
- Data visualization through Tableu Public.

## Introduction
### Company background

Cyclistic is a bike-sharing company based in Chicago that launched in 2016. The company features more than 5,800 bicycles that are geo-tracked and locked into a network of almost 700 stations across Chigaco. Apart from the traditional bikes, Cyclystic makes its service more inclusive by also offering reclining bikes, hand tricycles, and cargo-bikes. In this sense, the bikes can be unlocked from one station and returned to any other station in the system anytime. 

So far, it is known that most users opt for traditional bikes, whereas 8% of riders use the assistive options. Moreover, most riders use the service 
for leisure purposes, but 30%  of them use bikes as a way of commuting to work every day. Cyclistic appeals to a broad consumer segment and the consumers of the service have the possibility of choosing between three plans: single-ride passes, full-day passes, and annual memberships. Those who choose single-ride passes and full-day passes are referred to as "casual riders" while the riders who acquire an annual membership are referred to as "Cyclistic members".

### Business task

The company finance analysts have concluded that Cyclistic members are more profitable than casual riders. In this context, Lily Moreno, the director of marketing and manager of the data analyst team, believes that the key to the future growth of the company relies on maximizing the number of annual members. Thus, to design good marketing strategies, it is crucial to analyze the trends and behaviors of the two customer segments to understand how bike usage differs between casual riders and Cyclistic members.

### Key Business Questions

1. How do annual members and casual riders use Cyclistic bikes differently?

2. Why would casual riders buy Cyclistic annual memberships?

3. How can Cyclistic use digital media to influence casual riders to become members?

## Data Processing
### Data source description
As already mentioned, for this study a database of the fictitious company Cyclistic was used. In this context, the trips made by the users of the service in the period between August 2021 and July 2022 were analyzed. The data is provided in .csv format, each one corresponding to a month of that period. 

The data is provided by the company in an organized structure, containing 13 columns that specify each trip. In this context, there is information about the trip identification (`ride_id`), the type of bike used (`rideable_type`), information about the trip times (`started_at` and `ended_at`), the type of subscription of the service user (`member_casual`) among other information.

There is no information in the database that can identify the users of each trip, such as user name or credit card information. Therefore, it is not possible to know, for example, in which area those users live or how much specific casual users would profit from getting a membership. 

### Cleaning and processing data

Firstly, the .csv files were opened using Microsoft Excel to get a general idea of the values of each variable contained in the spreadsheets and to know which variables would be of most importance for the data analysis. For the data cleaning and processing Microsoft SQL Server Management Studio was used, in which the following steps were performed:

1. The UNION query was used to concatenate the referenced files of each month into a single data set.

2. The features that presented null values were disregarded. Also, since all rides must contain a value for arrival station (`start_station_name`) and departure station (`end_station_name`), temporary stations or those with invalid names were disregarded.

3. Using the data information of each ride (`started_at` and `ended_at`), the following features were created:
- `ride_duration`: informing the duration of each ride;
- `start_hour`: informing the beginning of each ride;
- `start_day`: informing the day of the week of each started ride;
- `start_month`: informing the month of each started ride.

4. Finally, for the data analysis, only rides with duration with more than five minutes were considered.

## Data Analysis and Visualization
### Trip duration overview
### Hourly trend
### Dayly trend
### Monthly trend
### Bike preferences 
### Geographic overview of departure and arrival stations
### Top 10 stations (departure and arrival)
## Conclusion
### Sumary of Analysis
### Recomendations based on Analysis



