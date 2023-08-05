-- The Data that we are going to use

SELECT *
FROM [Table D ]

SELECT *
FROM [table V]


-- Total Case VS Total Deaths
-- Show the likelihood of dying if you contract covid in your country

SELECT location,date,total_cases,total_deaths,(cast(total_deaths as numeric)/CAST(total_cases as numeric))*100 as DeathPercentage
FROM [Table D ]
ORDER BY 1,2


-- Total Case VS Population
-- Show what percentage of population infected with covid

SELECT location,date,Population,total_cases, (cast(total_cases as numeric)/Population) as percentage_populationinfected
FROM [Table D ]
ORDER BY 1,2


-- countries with Highest Infection Rate compared to Population

SELECT location,Population,max(total_cases) as HighInfection_count, (MAX(total_cases)/Population)*100 as percentagePopulationInfection
FROM [Table D ]
GROUP BY location, Population
ORDER BY percentagePopulationInfection DESC 


-- Countries with Highest Death Count Per Population

SELECT location,max(CAST( total_deaths as int)) as TotaldeathsCount
FROM [Table D ]
WHERE continent is not null
GROUP BY location 
ORDER BY TotaldeathsCount DESC


-- Showing Contintents with Highest Death count Per Population

SELECT continent,max(cast( total_deaths as int)) as TotaldeathsCount
FROM [Table D ]
WHERE continent is not null
GROUP BY continent
ORDER BY TotaldeathsCount DESC


-- Global Numbers

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/ SUM(new_cases) *100 as DeathPercentage
FROM [Table D ]
WHERE continent is not null


-- Total Population VS Vaccinations
-- Shows Percentage Of Population that has recieved at least one Covid Vaccine

with PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location ,dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as numeric)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM [Table D ] dea
JOIN [Table V] vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac


--Using Temp Table to Perform Calculation on Partition By in previous query

Drop Table if exists #PrecentPopulationVaccinated
Create Table #PrecentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population Numeric,
New_vaccinations Numeric,
RollingPeopleVaccinated Numeric,
)
Insert Into #PrecentPopulationVaccinated
SELECT dea.continent, dea.location ,dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as numeric)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM [Table D ] dea
JOIN [Table V] vac ON dea.location = vac.location AND dea.date = vac.date

select *, (RollingPeopleVaccinated/population)*100
from #PrecentPopulationVaccinated



-- Creating a VIEW for side calculation

 CREATE VIEW side_calculation as

SELECT [Table D ].location,[Table D ].population,[Table D ].date,[Table D ].new_cases,[Table D].new_deaths,[Table V].new_vaccinations
FROM [Table D ]
JOIN [Table V] ON [Table D ].location = [Table V].location AND [Table D ].date = [Table V].date
WHERE [Table D ].continent is not null


-- Global Numbers

SELECT SUM(new_cases) as total_cases,SUM(new_deaths) as total_deaths, SUM(cast(new_vaccinations as numeric)) as total_vaccinations,(SUM(new_deaths)/SUM(new_cases))*100 as Deaths_Precentage
FROM side_calculation



