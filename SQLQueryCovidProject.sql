--Select Data that we are going to be using
Select location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
order by 1,2

--Total case vs. Total deaths (This shows the liklihood fo dying if you contract Covid in the United States)
Select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
From CovidDeaths
Where location = 'United States'
order by 1,2

--Total Cases vs. Population (This shows what percentage of the United States popluation that got Covid)
Select location, date, total_cases, population, (total_cases/population) * 100 as InfectedPercentage
From CovidDeaths
Where location = 'United States'
order by 1,2

--Countries with highest infection rate compared to poulation
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)) * 100 as InfectedPercentage
From CovidDeaths
Group by location, population
order by 4 desc

--Countries with the highest death count per population
Select location, population, MAX(total_deaths) as TotalDeathCount, MAX((total_deaths/population)) * 100 as DeathRate
From CovidDeaths
Where continent is not null --(this takes out rows for groupings by continent)
Group by location, population
order by 3 desc

--Breaking out highest death count by continent
Select location, population, MAX(total_deaths) as TotalDeathCount, MAX((total_deaths/population)) * 100 as DeathRate
From CovidDeaths
Where continent is null
Group by location, population
order by 3 desc

--Global Death Percentage
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/ SUM(new_cases) *100 as DeathPercentage
From CovidDeaths
Where continent is not null
order by 1, 2

-- Total Population vs. Vaccinations
With cte(continent, location, date, population, new_vaccinations,total_vaccinations_by_country)
AS(
Select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(CAST(v.new_vaccinations as int)) OVER(Partition by d.location order by d.location, d.date) as total_vaccinations_by_country
From CovidDeaths D
Join CovidVaccs V
on d.location =  v.location and 
d.date = v.date
Where d.continent is not null)
Select *,(total_vaccinations_by_country/population)*100 as Vaccinated_percetage
from cte 
order by location, date

--Create view for data visualization
Create VIEW PercentPopVacc as 
Select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(CAST(v.new_vaccinations as int)) OVER(Partition by d.location order by d.location, d.date) as total_vaccinations_by_country
From CovidDeaths D
Join CovidVaccs V
on d.location =  v.location and 
d.date = v.date
Where d.continent is not null
	

