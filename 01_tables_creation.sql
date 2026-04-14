/*
 * TABLE 1:
 * Ceny potravin a mzdy v Ceske Republice sjednocene do urciteho obdobi (2006–2018) 
 */


DROP TABLE IF EXISTS t_denisa_bartonova_project_sql_primary_final CASCADE;

CREATE TABLE t_denisa_bartonova_project_SQL_primary_final AS
SELECT 
    cpc.name AS food_category,
    cpc.price_value,
    cpc.price_unit,
    cp.value AS food_price,
    cp.date_from,
    cp.date_to,
    cpa.value AS average_salary,
    cpa.payroll_year,
    cpaib.name AS industry_branch
FROM czechia_price cp
JOIN czechia_price_category cpc
    ON cp.category_code = cpc.code
JOIN czechia_payroll cpa
    ON DATE_PART('year', cp.date_from)::int = cpa.payroll_year
JOIN czechia_payroll_industry_branch cpaib
    ON cpa.industry_branch_code = cpaib.code
WHERE cpa.value_type_code = 5958
AND cp.region_code IS NULL;


/* 
 * TABLE 2:
 * Data o jinych statech ve stejnem obdobi (2006–2018) 
 */

DROP TABLE IF EXISTS t_denisa_bartonova_project_sql_secondary_final CASCADE;

CREATE TABLE t_denisa_bartonova_project_SQL_secondary_final AS
SELECT 
    c.country,
    e.year,
    e.gdp,
    e.population,
    e.gini
FROM countries c
JOIN economies e
    ON c.country = e.country
WHERE c.continent = 'Europe'
AND e.year BETWEEN 2006 AND 2018;

