-- SELECT DATA TO QUERY ABOUT TOTAL COVID CASES VS TOTAL DEATHS ON THE UNITED KINGDOM

SELECT location, date, total_cases, new_cases, total_deaths
FROM Covid_2023_Project..Covid_Dataset
WHERE location LIKE '%Kingdom%'
ORDER BY 1,2

--Looking at the UK Covid Total Cases vs Population
	--Shows what % of population got Covid

SELECT location, date, population, new_cases, new_deaths, total_cases, total_deaths, (total_cases/population)*100 AS PercentPopulationInfected
FROM Covid_2023_Project..Covid_Dataset
WHERE location LIKE '%Kingdom%'
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths
-- It shows the likelihood of dying if you contract covid 19 in the UK

ALTER TABLE Covid_2023_Project..Covid_Dataset ALTER COLUMN total_deaths NVARCHAR(255)
ALTER TABLE Covid_2023_Project..Covid_Dataset ALTER COLUMN total_cases FLOAT
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS "Death_Percentage"
FROM Covid_2023_Project..Covid_Dataset
WHERE location LIKE '%Kingdom%'
ORDER BY 1,2

-- Total Cases vs Total Deaths
-- It shows the UK total figures

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
FROM Covid_2023_Project..Covid_Dataset
WHERE location LIKE '%Kingdom%'
--GROUP BY date
ORDER BY 1,2

-- SELECT DATA TO QUERY ABOUT TOTAL CASES VS TOTAL DEATHS WORLDWIDE
	--Looking at countries with the highest infection rate compared to population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM Covid_2023_Project..Covid_Dataset
WHERE continent is not NULL -- Exclude continents from location
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

	--Showing the countries with the highest death count per population

SELECT location, population, MAX(cast(total_deaths as int)) AS TotalDeathCount, MAX((total_deaths/population))*100 AS Percent_Death
FROM Covid_2023_Project..Covid_Dataset
WHERE continent is not NULL
GROUP BY location, population
ORDER BY TotalDeathCount DESC


-- BREAKING IT DOWN BY CONTINENT

-- Showing continents with the highest death count per population

SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM Covid_2023_Project..Covid_Dataset
WHERE location NOT LIKE '%income%' AND continent is NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
FROM Covid_2023_Project..Covid_Dataset
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2



