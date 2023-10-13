/*

Queries used for Tableau Project

*/
--1.
-- The UK Total Cases vs Total Deaths

SELECT location, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
FROM Covid_2023_Project..Covid_Dataset
WHERE location LIKE '%Kingdom%'
GROUP by location
ORDER BY 1,2


--2.
-- By Continent, Total Cases vs Total Deaths and Death Percentage

SELECT location, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM Covid_2023_Project..Covid_Dataset
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union')
AND location NOT LIKE '%income%'
GROUP BY location
ORDER BY total_deaths DESC

-- It shows the total figures

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM Covid_2023_Project..Covid_Dataset
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union')
AND location NOT LIKE '%income%'
ORDER BY total_deaths DESC

--3.
--Worldwide Highest Infection Count and Percentage of Population Infected

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Covid_2023_Project..Covid_Dataset
WHERE continent IS NOT NULL
Group by Location, Population
order by PercentPopulationInfected desc

--3.1.
--Worldwide Highest Infection Count and Percentage of Population Infected
	--With date

Select Location, Population, date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Covid_2023_Project..Covid_Dataset
WHERE continent IS NOT NULL
Group by Location, Population, date
order by PercentPopulationInfected desc
