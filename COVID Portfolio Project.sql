Select *
FROM PortfolioProject..CovidDeaths
order by 3,4

--Select *
--FROM PortfolioProject..CovidVaccinations
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
order by 1,2

--Looking at Total cases vs Total deaths
--Shows likelihood of dying if you contact covid

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%states%'
order by 1,2

--Looking at total cases vs population
--Shows what percentage of population got covid

Select location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%fric%'
order by 1,2

--Looking at countries with highest infection reate compared to population

Select location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentagePopulationInfection
FROM PortfolioProject..CovidDeaths
--WHERE location like '%fric%'
Group by location, population
order by PercentagePopulationInfection desc

--Shoeing countries with the highest death count per population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%fric%'
where continent is not null
Group by location
order by TotalDeathCount desc

--Grouping by continent

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%fric%'
where continent is not null
Group by continent
order by TotalDeathCount desc

--Showing continents with the highest death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%fric%'
where continent is not null
Group by continent
order by TotalDeathCount desc

--Global Numbers

Select SUM(new_cases), SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/SUM(new_cases)*100 
as DeathPercentage
--(total_cases/population)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%fric%'
WHERE continent is not null
group by date
order by 1,2

--Looking at Total Population vs Vaccinations


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
    order by 2,3


	--Using CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
    --order by 2,3
)
Select *
From PopvsVac

--Uding TEMP TABLE

Create Table #PercentPoulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric, 
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT into #PercentPoulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
    --order by 2,3

	Select *, (RollingPeopleVaccinated/population)*100
From #PercentPoulationVaccinated

--Creating view to store data for later visualizations

Create View aPercentPoulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From #PercentPoulationVaccinated