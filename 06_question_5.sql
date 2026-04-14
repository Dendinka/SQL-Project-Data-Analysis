/*
 * 5. Ma vyska HDP vliv na zmeny ve mzdach a cenach potravin? Neboli, pokud HDP vzroste vyrazneji v jednom roce, projevi se to na cenach potravin či mzdach ve stejnem nebo nasledujicim roce vyraznejsim rustem?
 */

WITH gdp_trend AS (
    -- KROK 1: Vypocet mezirocni zmeny HDP
    SELECT 
        year,
        gdp,
        LAG(gdp) OVER (ORDER BY year) AS prev_gdp,
        ROUND((gdp::numeric / LAG(gdp) OVER (ORDER BY year)::numeric - 1) * 100, 2) AS gdp_growth
    FROM t_denisa_bartonova_project_SQL_secondary_final
    WHERE country = 'Czech Republic'
),
salary_trend AS (
    -- KROK 2: Prumerna mzda za celou CR v kazdem roce
    SELECT 
        payroll_year,
        AVG(average_salary) AS avg_salary,
        LAG(AVG(average_salary)) OVER (ORDER BY payroll_year) AS prev_salary
    FROM t_denisa_bartonova_project_SQL_primary_final
    GROUP BY payroll_year
),
food_trend AS (
    -- KROK 3: Prumerna cena potravin v kazdem roce
    SELECT 
        payroll_year,
        AVG(food_price / price_value) AS avg_food_price,
        LAG(AVG(food_price / price_value)) OVER (ORDER BY payroll_year) AS prev_food_price
    FROM t_denisa_bartonova_project_SQL_primary_final
    GROUP BY payroll_year
)
-- FINALNI KROK: Spojeni vsech trendu do jedne tabulky pro porovnani
SELECT 
    g.year,
    g.gdp_growth AS gdp_growth_pct,
    ROUND((((s.avg_salary / s.prev_salary) - 1) * 100)::numeric, 2) AS salary_growth_pct,
    ROUND((((f.avg_food_price / f.prev_food_price) - 1) * 100)::numeric, 2) AS food_growth_pct
FROM gdp_trend g
JOIN salary_trend s ON g.year = s.payroll_year
JOIN food_trend f ON g.year = f.payroll_year
WHERE g.prev_gdp IS NOT NULL
ORDER BY g.year;