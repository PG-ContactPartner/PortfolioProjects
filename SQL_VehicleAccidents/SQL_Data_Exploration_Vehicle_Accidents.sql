--Exploratory data analysis.

	-- Check tables
SELECT *
FROM VehicleAccident.dbo.accident
	
SELECT * 
FROM VehicleAccident.dbo.vehicle
------------------------------------------------------------------------------------
--Question 1: How many accidents occurred in urban areas versus rural areas?

SELECT Area, COUNT(Area) AS 'TotalAccidents'
FROM VehicleAccident.dbo.accident
GROUP BY Area

--Question 2: Which day of the week has the highest number of accidents?

SELECT Day, COUNT(AccidentIndex) as 'Accidents_per_day_of_the_Week'
FROM VehicleAccident.dbo.accident
GROUP BY Day
ORDER BY Accidents_per_day_of_the_Week DESC

--Question 3: What is the average age of vehicles involved in accidents based on their type?

SELECT VehicleType,
	COUNT(AccidentIndex) AS 'Total Accidents',
	AVG(CAST(AgeVehicle AS INT)) AS'AverageVehicleAge'
FROM VehicleAccident.dbo.vehicle
WHERE AgeVehicle IS NOT NULL
GROUP BY VehicleType 
ORDER BY 'Total Accidents' DESC

--Question 4: Can we identify trends in accidents based on the age of vehicles involved?

SELECT
	AgeGroup,
	COUNT(AccidentIndex) AS 'TotalAccidents',
	AVG(CAST(AgeVehicle AS INT)) AS'AverageVehicleAge'
FROM(
	SELECT 
		AccidentIndex,
		AgeVehicle,
		CASE	
			WHEN AgeVehicle BETWEEN 0 AND 4 THEN 'New'
			WHEN AgeVehicle BETWEEN 5 AND 9 THEN 'Regular'
			ELSE 'Old'
		END AS 'AgeGroup'
	FROM VehicleAccident.dbo.vehicle
	WHERE AgeVehicle IS NOT NULL
)AS SubQuery
GROUP BY AgeGroup
ORDER BY AverageVehicleAge DESC

--Question 5: Are there specific weather/road/light conditions that contribute to severe accidents?

SELECT
	WeatherConditions,
	COUNT(Severity) AS 'TotalAccidents'
FROM VehicleAccident.dbo.accident
WHERE Severity = 'Fatal'
GROUP BY WeatherConditions
ORDER BY 'TotalAccidents' DESC;

SELECT
	RoadConditions,
	COUNT(Severity) AS 'TotalAccidents'
FROM VehicleAccident.dbo.accident
WHERE Severity = 'Fatal'
GROUP BY RoadConditions
ORDER BY 'TotalAccidents' DESC;

SELECT
	LightConditions,
	COUNT(Severity) AS 'TotalAccidents'
FROM VehicleAccident.dbo.accident
WHERE Severity = 'Fatal'
GROUP BY LightConditions
ORDER BY 'TotalAccidents' DESC;

--Question 6: Do accidents often involve impacts on the left-hand side of vehicles?

SELECT
	LeftHand,
	COUNT(AccidentIndex) AS 'TotalAccidents'
FROM VehicleAccident.dbo.vehicle
WHERE LeftHand LIKE'N%' OR LeftHand LIKE 'Y%' -- Exclude 'Data missing...'
GROUP BY LeftHand
ORDER BY 'TotalAccidents' DESC

--Question 7: Are there any relationship between journey purposes and the severity of accidents?

SElECT
	V.JourneyPurpose,
	COUNT(A.Severity) AS 'TotalAccidents',
	CASE
		WHEN COUNT(A.Severity) BETWEEN 0 AND 1000 THEN 'Low'
		WHEN COUNT(A.Severity) BETWEEN 1001 AND 3000 THEN 'Moderate'
		ELSE 'High'
		END AS 'Level'
FROM VehicleAccident.dbo.accident A
JOIN VehicleAccident.dbo.vehicle V
	ON V.AccidentIndex = A.AccidentIndex
GROUP BY V.JourneyPurpose
ORDER BY 'TotalAccidents' DESC

--Question 8: Calculate the average age of vehicles involved in accidents , considering day light and point of impact.

SELECT
	A.LightConditions,
	V.PointImpact,
	AVG(CAST(V.AgeVehicle AS INT)) AS 'AverageVehicleAge',
	COUNT(V.PointImpact) AS 'TotalAccidents'
FROM VehicleAccident.dbo.vehicle V
	JOIN VehicleAccident.dbo.accident A
		ON A.AccidentIndex =V.AccidentIndex
GROUP BY A.LightConditions, V.PointImpact
ORDER BY A.LightConditions, V.PointImpact
