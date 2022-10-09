Select *
From Covid..Coviddeaths
where continent is not null
order by 3,5

--select *
--from COVID..CovidVaccines
--order by 3,4

--select data that we are going to be using 

select location, date, total_cases, new_cases, total_deaths, population
from Covid..Coviddeaths
order by 1,2

-- loking at total cases vs total Deaths
-- show likelihood of dying if you contract covied in egypt
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from covid..Coviddeaths
where location like '%egypt%'
order by 1,2

-- total cases vs populatio
--show percentage of population who got COVID
select location, date, total_cases, population, (total_cases/population)*100 as infectionPercentage
from covid..Coviddeaths
--where location like '%egypt%'
order by 1,2

--contries with highest infection rate comapred to population
select location, population, max(total_cases) as highestinfection, max(total_deaths/total_cases)*100 as PercentPopulationInfected
from covid..Coviddeaths
--where location like '%egypt%'
group by location, population
order by percentPopulationInfected DESC


--contries with highest mortality
select location, max(cast(total_deaths as int)) as TotalDeathCount
from covid..Coviddeaths
--where location like '%egypt%'
where continent is not null
group by location, population
order by TotalDeathCount DESC

-- BREAK THINGS DOWN BY CONTINENT
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from covid..Coviddeaths
--where location like '%egypt%'
where continent is not null
group by continent
order by TotalDeathCount DESC

--contintents with the highest death count per population
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from covid..Coviddeaths
--where location like '%egypt%'
where continent is not null
group by continent
order by TotalDeathCount DESC

--GLOBAL NUMBERS
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths , sum(cast(new_deaths as int))/sum(new_cases)*100 as Deathpercentage
from covid..Coviddeaths
--where location like '%egypt%'
where continent is not null
--group by date
order by 1,2 

--TOTAL POPULATION VS VACCINATIONS

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPoepleVaccinated
,--(RollingPoepleVaccinated/population)*100
From COVID..CovidDeaths dea
join COVID..CovidVaccines vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE
with POPvsVAC (continent, location, date, population, New_Vacciations, RollingPoepleVaccinated) 
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPoepleVaccinated
--(RollingPoepleVaccinated/population)*100
From COVID..CovidDeaths dea
join COVID..CovidVaccines vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
SELECT *, (RollingPoepleVaccinated/population)*100
FROM POPvsVAC

--TEMP TABLE
Drop table if exists #PercetPopulationVaccinated
create table #PercetPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPoepleVaccinated numeric
)

insert into #PercetPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPoepleVaccinated
--(RollingPoepleVaccinated/population)*100
From COVID..CovidDeaths dea
join COVID..CovidVaccines vac
     on dea.location = vac.location
	 and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

SELECT *, (RollingPoepleVaccinated/population)*100
FROM #PercetPopulationVaccinated

--creating view to store data for later visualization

Create View PercetPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPoepleVaccinated
--(RollingPoepleVaccinated/population)*100
From COVID..CovidDeaths dea
join COVID..CovidVaccines vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select*
From PercetPopulationVaccinated