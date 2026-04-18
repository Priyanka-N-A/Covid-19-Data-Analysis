use portpolioproject;
show tables;

select count(iso_code) from covid_VACCINATIONS;
select count(iso_code) from covid_DEATHS;

SELECT MAX(TOTAL_DEATHS) as total_deaths  FROM COVID_DEATHS
WHERE continent="asia";

select location, COUNT(total_deaths) AS TOT_DEATHS FROM COVID_DEATHS
WHERE CONTINENT="ASIA"
GROUP BY LOCATION
ORDER BY TOT_DEATHS DESC;


SELECT DISTINCT CONTINENT FROM COVID_DEATHS;
SELECT DISTINCT location FROM COVID_DEATHS;

-- Shows each country’s daily record of total COVID deaths and vaccinations (joined by date)
SELECT
  d.location,
  d.date,
  d.total_deaths,
  v.total_vaccinations
FROM Covid_Deaths d
INNER JOIN Covid_Vaccinations v
  ON d.iso_code = v.iso_code
  AND d.date = v.date
WHERE d.continent IS NOT NULL -- excludes World / continent aggregate rows
ORDER BY d.location, d.date;

-- Shows each country’s daily totals for deaths and vaccinations,
-- along with the death percentage (deaths as % of total cases)
SELECT d.location, d.date,
  d.total_deaths, v.total_vaccinations,
  ROUND((d.total_deaths * 100.0 / NULLIF(d.total_cases, 0)), 2) AS death_pct
FROM Covid_Deaths d INNER JOIN Covid_Vaccinations v
  ON d.iso_code = v.iso_code AND d.date = v.date
WHERE d.continent IS NOT NULL;

-- Shows country-level records where death/case data exists
-- but there is NO matching vaccination data for the same date
SELECT
  d.location,
  d.date,
  d.total_cases,
  d.total_deaths,
  v.total_vaccinations -- will always be NULL here
FROM Covid_Deaths d
LEFT JOIN Covid_Vaccinations v
  ON d.iso_code = v.iso_code
  AND d.date = v.date
WHERE d.continent IS NOT NULL -- exclude aggregate rows
  AND v.iso_code IS NULL -- keep only rows with NO vaccination match
ORDER BY d.location, d.date;

-- Counts how many days each country has no matching vaccination data,
-- sorted from highest to lowest missing days
SELECT d.location, COUNT(*) AS days_without_vax_data
FROM Covid_Deaths d
LEFT JOIN Covid_Vaccinations v
  ON d.iso_code = v.iso_code AND d.date = v.date
WHERE d.continent IS NOT NULL
  AND v.iso_code IS NULL
GROUP BY d.location
ORDER BY days_without_vax_data DESC;

-- Counts rows where death records exist but have no matching vaccination data
SELECT 'deaths only' AS row_source, COUNT(*) AS row_count
FROM Covid_Deaths d
LEFT JOIN Covid_Vaccinations v
  ON d.iso_code = v.iso_code
  AND d.date = v.date
WHERE v.iso_code IS NULL;

-- Combines deaths and vaccination data to simulate a FULL OUTER JOIN,
-- labeling each row as 'both', 'deaths only', or 'vax only' depending on data availability
SELECT
  COALESCE(d.location, v.location) AS location,
  COALESCE(d.date, v.date) AS date,
  d.total_deaths,
  v.total_vaccinations,
  CASE
    WHEN d.iso_code IS NULL THEN 'vax only'
    WHEN v.iso_code IS NULL THEN 'deaths only'
    ELSE 'both'
  END AS row_source

FROM Covid_Deaths d
LEFT JOIN Covid_Vaccinations v
  ON d.iso_code = v.iso_code
  AND d.date = v.date

UNION

SELECT
  COALESCE(d.location, v.location) AS location,
  COALESCE(d.date, v.date) AS date,
  d.total_deaths,
  v.total_vaccinations,
  CASE
    WHEN d.iso_code IS NULL THEN 'vax only'
    WHEN v.iso_code IS NULL THEN 'deaths only'
    ELSE 'both'
  END AS row_source

FROM Covid_Deaths d
RIGHT JOIN Covid_Vaccinations v
  ON d.iso_code = v.iso_code
  AND d.date = v.date

ORDER BY location, date;

-- Merges deaths and vaccination data into one dataset (simulating FULL OUTER JOIN),
-- including all records and tagging each as 'both', 'deaths only', or 'vax only'
SELECT
  COALESCE(d.location, v.location)   AS location,
  COALESCE(d.date, v.date)           AS date,
  COALESCE(d.continent, v.continent) AS continent,
  d.population,
  d.total_cases,
  d.total_deaths,
  d.new_deaths,
  v.total_vaccinations,
  v.people_vaccinated,
  v.people_fully_vaccinated,
  v.new_vaccinations,
  v.positive_rate,
  CASE
    WHEN d.iso_code IS NULL THEN 'vax only'
    WHEN v.iso_code IS NULL THEN 'deaths only'
    ELSE 'both'
  END AS row_source

FROM Covid_Deaths d
LEFT JOIN Covid_Vaccinations v
  ON d.iso_code = v.iso_code
  AND d.date = v.date

UNION

SELECT
  COALESCE(d.location, v.location)   AS location,
  COALESCE(d.date, v.date)           AS date,
  COALESCE(d.continent, v.continent) AS continent,
  d.population,
  d.total_cases,
  d.total_deaths,
  d.new_deaths,
  v.total_vaccinations,
  v.people_vaccinated,
  v.people_fully_vaccinated,
  v.new_vaccinations,
  v.positive_rate,
  CASE
    WHEN d.iso_code IS NULL THEN 'vax only'
    WHEN v.iso_code IS NULL THEN 'deaths only'
    ELSE 'both'
  END AS row_source

FROM Covid_Deaths d
RIGHT JOIN Covid_Vaccinations v
  ON d.iso_code = v.iso_code
  AND d.date = v.date
ORDER BY location, date;


-- Creates a complete combined dataset of deaths and vaccination records,
-- using LEFT + RIGHT JOIN (FULL OUTER JOIN simulation),
-- and labels each row based on whether data exists in one or both tables
SELECT
  COALESCE(d.location, v.location)   AS location,
  COALESCE(d.date, v.date)           AS date,
  COALESCE(d.continent, v.continent) AS continent,
  d.population,
  d.total_cases,
  d.total_deaths,
  d.new_deaths,
  v.total_vaccinations,
  v.people_vaccinated,
  v.people_fully_vaccinated,
  v.new_vaccinations,
  v.positive_rate,
  CASE
    WHEN d.iso_code IS NULL THEN 'vax only'
    WHEN v.iso_code IS NULL THEN 'deaths only'
    ELSE 'both'
  END AS row_source

FROM Covid_Deaths d
LEFT JOIN Covid_Vaccinations v
  ON d.iso_code = v.iso_code
  AND d.date = v.date

UNION

SELECT
  COALESCE(d.location, v.location)   AS location,
  COALESCE(d.date, v.date)           AS date,
  COALESCE(d.continent, v.continent) AS continent,
  d.population,
  d.total_cases,
  d.total_deaths,
  d.new_deaths,
  v.total_vaccinations,
  v.people_vaccinated,
  v.people_fully_vaccinated,
  v.new_vaccinations,
  v.positive_rate,
  CASE
    WHEN d.iso_code IS NULL THEN 'vax only'
    WHEN v.iso_code IS NULL THEN 'deaths only'
    ELSE 'both'
  END AS row_source

FROM Covid_Deaths d
RIGHT JOIN Covid_Vaccinations v
  ON d.iso_code = v.iso_code
  AND d.date = v.date

ORDER BY location, date;



