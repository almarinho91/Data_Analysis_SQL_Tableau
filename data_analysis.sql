----------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------- DATA PROCESSING AND ANALYSIS -------------------------------------------------------------
--Author: André Lopes Marinho

---------------------------------------------------------> COMBINING DATA AND CLEANING 

WITH
---------------------------------------------------------> Combine all datasets into one 
year_dataset AS 
(
	SELECT * 
	FROM Cyclistic..[202108-divvy-tripdata]
	UNION ALL
	SELECT * 
	FROM Cyclistic..[202109-divvy-tripdata]
	UNION ALL
	SELECT * 
	FROM Cyclistic..[202110-divvy-tripdata]
	UNION ALL
	SELECT * 
	FROM Cyclistic..[202111-divvy-tripdata]
	UNION ALL
	SELECT * 
	FROM Cyclistic..[202112-divvy-tripdata]
	UNION ALL
	SELECT * 
	FROM Cyclistic..[202201-divvy-tripdata]
	UNION ALL
	SELECT * 
	FROM Cyclistic..[202202-divvy-tripdata]
	UNION ALL
	SELECT * 
	FROM Cyclistic..[202203-divvy-tripdata]
	UNION ALL
	SELECT * 
	FROM Cyclistic..[202204-divvy-tripdata]
	UNION ALL
	SELECT * 
	FROM Cyclistic..[202205-divvy-tripdata]
	UNION ALL
	SELECT * 
	FROM Cyclistic..[202206-divvy-tripdata]
	UNION ALL
	SELECT * 
	FROM Cyclistic..[202207-divvy-tripdata]
),
---------------------------------------------------------> Clean the year dataset 
cleaned_data AS
(
	SELECT *
	FROM year_dataset 
	WHERE start_station_name NOT LIKE '%NULL%' --Empty values
		AND end_station_name NOT LIKE '%NULL%'
		AND start_lat  NOT LIKE '%NULL%'
		AND start_lng  NOT LIKE '%NULL%'
		AND end_lat  NOT LIKE '%NULL%'
		AND end_lng NOT LIKE '%NULL%'
		AND member_casual NOT LIKE '%NULL%'
		AND start_station_name NOT LIKE '%*%' --Invalid stations
		AND end_station_name NOT LIKE '%*%'
		AND start_station_name NOT LIKE '%(Temp)%'
		AND end_station_name NOT LIKE '%(Temp)%'
		
),

---------------------------------------------------------> Adds information to the dataset 
add_columns AS
(
	SELECT *,
	DATEDIFF(MINUTE, started_at, ended_at) AS ride_duration,
	DATENAME(MONTH, started_at) + '/' + DATENAME(YEAR, started_at) AS start_month,
	DATENAME(WEEKDAY, started_at) AS start_day,
	CASE
		WHEN DATEPART(HOUR, started_at) < 12 THEN DATENAME(HOUR, started_at) + ' AM'
		WHEN DATEPART(HOUR, started_at) > 11 THEN DATENAME(HOUR, started_at) + ' PM'
	END	
		AS start_hour
	FROM cleaned_data
),
---------------------------------------------------------> Final dataset 
final_data AS
(
	SELECT *
	FROM add_columns
	WHERE ride_duration > 5
),

---------------------------------------------------------> EXPLORING AND ANALYSING DATA
---------------------------------------------------------> Average trip duration per member type
count_membership AS
(
	SELECT 
		COUNT(member_casual) as count_membership
	FROM final_data
		WHERE member_casual = 'casual'
		OR	member_casual = 'member'
	GROUP BY member_casual
),

avg_by_member AS
(
	SELECT 
		AVG(ride_duration) as avg_duration,
		member_casual
	FROM final_data
		WHERE member_casual = 'casual'
		OR	member_casual = 'member'
	GROUP BY member_casual
),
---------------------------------------------------------> Sum of trips duration per member type
sum_by_member AS
(
	SELECT 
		SUM(ride_duration) as sum_duration,
		member_casual
	FROM final_data
		WHERE member_casual = 'casual'
		OR	member_casual = 'member'
	GROUP BY member_casual
),
---------------------------------------------------------> Hourly trip trend per member type: member
hourly_trend_member AS
(
	SELECT 
		COUNT(member_casual) as count_member,
		start_hour
	FROM final_data
		WHERE member_casual = 'member'
	GROUP BY start_hour
),
---------------------------------------------------------> Hourly trip trend per member type: casual
hourly_trend_casual AS
(
	SELECT 
		COUNT(member_casual) as count_casual,
		start_hour
	FROM final_data
		WHERE member_casual = 'casual'
	GROUP BY start_hour
),
---------------------------------------------------------> Daily trip trend per member type: member
daily_trend_member AS
(
	SELECT 
		COUNT(member_casual) as count_member,
		start_day
	FROM final_data
		WHERE member_casual = 'member'
	GROUP BY start_day
),
---------------------------------------------------------> Daily trip trend per member type: casual
daily_trend_casual AS
(
	SELECT 
		COUNT(member_casual) as count_casual,
		start_day
	FROM final_data
		WHERE member_casual = 'casual'
	GROUP BY start_day
),
---------------------------------------------------------> Monthly trip trend per member type: member
monthly_trend_member AS
(
	SELECT 
		COUNT(member_casual) as count_member,
		start_month
	FROM final_data
		WHERE member_casual = 'member'
	GROUP BY start_month
),
---------------------------------------------------------> Monthly trip trend per member type: casual
monthly_trend_casual AS
(
	SELECT 
		COUNT(member_casual) as count_casual,
		start_month
	FROM final_data
		WHERE member_casual = 'casual'
	GROUP BY start_month
),
---------------------------------------------------------> Bike preference per member type: casual
type_trend_casual AS
(
	SELECT 
		COUNT(member_casual) as count_casual,
		rideable_type, 
		AVG(ride_duration) as avg_duration
	FROM final_data
		WHERE member_casual = 'casual'
	GROUP BY rideable_type
),
---------------------------------------------------------> Bike preference per member type: member
type_trend_member AS
(
	SELECT 
		COUNT(member_casual) as count_member,
		rideable_type,
		AVG(ride_duration) as avg_duration
	FROM final_data
		WHERE member_casual = 'member'
	GROUP BY rideable_type
),
---------------------------------------------------------> Departure station per member type: casual
casual_depart_station AS
(
	SELECT 
		COUNT(member_casual) AS count_casual, 
		start_station_name
	FROM final_data
	WHERE member_casual = 'casual' 
	GROUP BY start_station_name
),
---------------------------------------------------------> Departure station per member type: member
member_depart_station AS
(
	SELECT 
		COUNT(member_casual) AS count_member, 
		start_station_name
	FROM final_data
	WHERE member_casual = 'member' 
	GROUP BY start_station_name
),
---------------------------------------------------------> Departure station per member type
depart_station AS
(
	SELECT 
		cds.start_station_name, 
		cds.count_casual, 
		mds.count_member
	FROM casual_depart_station cds
	  JOIN member_depart_station mds
	  ON cds.start_station_name = mds.start_station_name
),

----------------------------------------------------------> GROUP departing station name with distinct Latitude and Altitude 
depart_latlng AS
(
	SELECT DISTINCT 
		start_station_name, 
		ROUND(AVG(start_lat),4) AS dep_lat, 
		Round(AVG(start_lng),4) AS dep_lng
	FROM final_data
	GROUP BY start_station_name
),

----------------------------------------------------------> Join location coordinate data with ridership count 
locationviz_depart AS
(
	SELECT 
		dl.start_station_name, 
		ds.count_casual, 
		ds.count_member, 
		dl.dep_lat, 
		dl.dep_lng
	FROM depart_station ds
	  JOIN depart_latlng dl
	  ON ds.start_station_name = dl.start_station_name
),


-----------------------------------------------------------> Find out total numbers of member or casual riders ARRIVING for respective stations <----------------------------------
casual_arrive_station AS
(
	SELECT 
		COUNT(member_casual) AS count_casual, 
		end_station_name
	FROM final_data
	WHERE member_casual = 'casual' 
	GROUP BY end_station_name
),

member_arrive_station AS
(
	SELECT 
		COUNT(member_casual) AS count_member, 
		end_station_name
	FROM final_data
	WHERE member_casual = 'member' 
	GROUP BY end_station_name 
),

---------------------------------------------------------> Join member & casual riders ON arriving bike stations 
arrive_station AS
(
	SELECT 
		cas.end_station_name,
		cas.count_casual, 
		mas.count_member
	FROM casual_arrive_station cas
	  JOIN member_arrive_station mas
	  ON cas.end_station_name = mas.end_station_name
),

----------------------------------------------------------> GROUP arriving station name with distinct Latitude and Altitude 
arrive_latlng AS
(
	SELECT DISTINCT 
		end_station_name, 
		ROUND(AVG(end_lat),4) AS arr_lat, 
		Round(AVG(end_lng),4) AS arr_lng
	FROM final_data
	GROUP BY end_station_name
),

---------------------------------------------------------> Join location coordinate data with ridership count 
locationviz_arrive AS
(
	SELECT 
		al.end_station_name, 
		ast.count_casual, 
		ast.count_member, 
		al.arr_lat, 
		al.arr_lng
	FROM arrive_station ast
	  JOIN arrive_latlng al
	  ON ast.end_station_name = al.end_station_name
)

SELECT *
FROM type_trend_member
ORDER BY count_member DESC

--ORDER BY 
--	CASE
--		WHEN start_month = 'August/2021' THEN 1
--		WHEN start_month = 'September/2021' THEN 2
--		WHEN start_month = 'October/2021' THEN 3
--		WHEN start_month = 'November/2021' THEN 4 
--		WHEN start_month = 'December/2021' THEN 5
--		WHEN start_month = 'January/2022' THEN 6
--		WHEN start_month = 'February/2022' THEN 7
--		WHEN start_month = 'March/2022' THEN 8
--		WHEN start_month = 'April/2022' THEN 9 
--		WHEN start_month = 'May/2022' THEN 10
--		WHEN start_month = 'June/2022' THEN 11
--		WHEN start_month = 'July/2022' THEN 12
--	END 

--ORDER BY 
--	CASE
--		WHEN start_hour = '0 AM' THEN 1
--		WHEN start_hour = '1 AM' THEN 2
--		WHEN start_hour = '2 AM' THEN 3
--		WHEN start_hour = '3 AM' THEN 4 
--		WHEN start_hour = '4 AM' THEN 5
--		WHEN start_hour = '5 AM' THEN 6
--		WHEN start_hour = '6 AM' THEN 7
--		WHEN start_hour = '7 AM' THEN 8
--		WHEN start_hour = '8 AM' THEN 9 
--		WHEN start_hour = '9 AM' THEN 10
--		WHEN start_hour = '10 AM' THEN 11
--		WHEN start_hour = '11 AM' THEN 12
--		WHEN start_hour = '12 PM' THEN 13
--		WHEN start_hour = '13 PM' THEN 14
--		WHEN start_hour = '14 PM' THEN 15
--		WHEN start_hour = '15 PM' THEN 16
--		WHEN start_hour = '16 PM' THEN 17
--		WHEN start_hour = '17 PM' THEN 18
--		WHEN start_hour = '18 PM' THEN 19
--		WHEN start_hour = '19 PM' THEN 20
--		WHEN start_hour = '20 PM' THEN 21 
--		WHEN start_hour = '21 PM' THEN 22
--		WHEN start_hour = '22 PM' THEN 23
--		WHEN start_hour = '23 PM' THEN 24
--	END 

-- ORDER BY 
--	CASE
--		WHEN start_day = 'Monday' THEN 1
--		WHEN start_day = 'Tuesday' THEN 2
--		WHEN start_day = 'Wednesday' THEN 3
--		WHEN start_day = 'Thursday' THEN 4 
--		WHEN start_day = 'Friday' THEN 5 
--		WHEN start_day = 'Saturday' THEN 6
--		WHEN start_day = 'Sunday' THEN 7
--	END 





