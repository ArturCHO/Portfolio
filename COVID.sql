select *
from PortfolioProject..CovidDeaths
order by 3,4

--select *
--from PortfolioProject..Covidvaccinations
--order by 3,4

--select data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

--looking at total cases vs total deaths
-- shows likelihood of dying if you contract covid in your country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%Poland%'
order by 1,2

-- Looking at Total cases vs population
-- Shows what percentage of population got COIVD
select location, date, population, total_cases, (total_cases/population)*100 as SickPercentage
from PortfolioProject..CovidDeaths
where location like '%Poland%'
order by 1,2

-- Looking at Countries with highest infection rate compared to population

select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%Poland%'
group by location, population
order by PercentPopulationInfected desc

-- Showing Countries with Highest death Count per population

select location, max(cast(total_deaths as int)) as TotalDeathsCount, max((total_deaths/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%Poland%'
where continent is not null
group by location
order by TotalDeathsCount desc

-- Lets brake things down by continent

select location, max(cast(total_deaths as int)) as TotalDeathsCount
from PortfolioProject..CovidDeaths
--where location like '%Poland%'
where continent is null
group by location
order by TotalDeathsCount desc

--Continents with the highest death count per population

select continent, max(cast(total_deaths as int)) as TotalDeathsCount
from PortfolioProject..CovidDeaths
--where location like '%Poland%'
where continent is not null
group by continent
order by TotalDeathsCount desc

--Global numbers

select date, sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int))/Sum(New_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2

--Global numbers sum

select sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int))/Sum(New_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--Total population vs vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3

--use CTE dodanie opcji liczenia procentu 

with PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac 

--Temp table
drop table if exists #PercentPopulationVaccinated

create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac on dea.location=vac.location and dea.date=vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated 
order by location

--create view to store data for later visualizations

Create view percentpopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select * from percentpopulationvaccinated
