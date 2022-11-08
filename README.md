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
The images in this section were made using Tableau Public.
### Overall trips overview
It can be seen below that most of the trips during the period under review were made by members of the service. This is equivalent to approximately 53% of the trips. 
<p align="center">
  <img src="/images/total_rides_per_membership.PNG" width="320" height="244">
</p>

However, when analyzing the total ride duration in minutes made by the two types of users, it can be seen that casual users represent more than 60% of the total amount of the trips‘ time. 
<p align="center">
  <img src="/images/total_ride_durationv2.png" width="539" height="134">
</p>

Furthermore, as can be observed in the graph that considers the average trip duration between the two types of users, it can be seen that casual users usually use the bicycles for almost twice as long as member users in one trip. This is probably because members use the service in their routines, such as going to work or school. Casual users, on the other hand, probably use the service for leisure.
<p align="center">
  <img src="/images/avg_ride_duration.png" width="539" height="134">
</p>

### Hourly trend
The hourly trip trend analysis shows that, for member users, there are two peaks in the day in which the bikes are more often used. This corresponds to 7:30 AM and 5:30 PM, which are in fact the usual time people go and return from work, respectively. As for casual members, the trend shows an increase in use during the day through the evening, with a peak also close to 5:30 PM.
<p align="center">
  <img src="/images/hourly_trend.PNG" width="544" height="420">
</p>

### Daily trend
The graph below shows the daily trip trend for both user types. In fact, it shows that the members use the service more uniformly throughout the week, with slightly less usage on the weekends. As for casual users, the number of trips tends to increase on the weekends.
<p align="center">
  <img src="/images/daily_trend.PNG" width="500" height="220">
</p>

### Monthly trend
The monthly trip trend for both users shows the same distribution for the analyzed period. It can be seen that rides for both user types have a maximum peak in the month of August/2021 and decrease more or less linearly reaching a minimum in January/2022. This can be explained by considering that in the same period, the temperatures also drop, which prevents people from using the service in colder seasons. From February/2022 until the end of the studied period, the trips by both users tend to increase, with a bigger growth rate in the period from April/2022 until June/2022.
<p align="center">
  <img src="/images/monthly_trend.PNG" width="544" height="420">
</p>

### Top 15 stations (departure and arrival)
#### Membership: Member
Below is a table with the count for the top 15 departure and arival stations for users who are members of the service.
<p align="center">
  <img src="/images/stations_member.png" width="600" height="420">
</p>

Moreover, to facilitate the visualization, is an image showing the geolocalization of such stations.
<p align="center">
  <img src="/images/geo_member.png">
</p>

#### Membership: Casual
Below is a table with the count for the top 15 departure and arival station for the casual users of the service.
<p align="center">
  <img src="/images/stations_casual.png" width="600" height="420">
</p>

Moreover, to facilitate the visualization, is an image showing the geolocalization of such stations.
<p align="center">
  <img src="/images/geo_casual.png">
</p>

## Conclusion
### Sumary of Analysis
- The analysis shows that, on average, 'casual' users make longer trips than 'member' users. Furthermore, considering the total travel time of the two user categories, 'casual' users represent the largest share;
- The trips of 'casual' users tend to grow during the day, peaking in the late afternoon. For 'member' users, there are two peaks during the day, in the morning and in the late afternoon;
- The trips of the 'casual' users have their peaks on the weekends, while the trips of the 'member' user have higher numbers throughout the whole week;
- During the analyzed one-year period, trips for both cases tend to decrease more dramatically at the beginning of autumn and grow more expressively at the beginning of spring;
- For the 'casual' users, the stations directly on the coast are the most used for departure and arrival. For 'member' users, these numbers are more evenly distributed among the stations.




