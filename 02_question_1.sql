/*
 * 1. Rostou v prubehu let mzdy ve vsech odvetvich, nebo v nekterych klesaji?
 */

WITH industry_year_average AS (
    -- KROK 1: Data za kazdy rok a sektor
    SELECT 
        industry_branch,
        payroll_year,
        ROUND(AVG(average_salary)) AS avg_salary_czk
    FROM t_denisa_bartonova_project_SQL_primary_final
    GROUP BY industry_branch, payroll_year
),
salary_trend_comparison AS (
    -- KROK 2: Funkce LAG pro porovnani s predchozim rokem
    SELECT 
        industry_branch,
        payroll_year,
        avg_salary_czk,
        LAG(avg_salary_czk) OVER (PARTITION BY industry_branch ORDER BY payroll_year) AS prev_year_salary
    FROM industry_year_average
)
-- KROK 3: Finalni vypocet
SELECT 
    industry_branch,
    payroll_year,
    avg_salary_czk,
    prev_year_salary,
    (avg_salary_czk - prev_year_salary) AS difference_czk,
    ROUND(((avg_salary_czk / prev_year_salary) - 1) * 100, 2) AS growth_percentage,
    CASE 
        WHEN avg_salary_czk > prev_year_salary THEN 'UP'
        WHEN avg_salary_czk < prev_year_salary THEN 'DOWN'
        ELSE 'STAGNATION'
    END AS trend
FROM salary_trend_comparison
WHERE prev_year_salary IS NOT NULL
ORDER BY industry_branch, payroll_year;

WITH industry_yearly_averages AS (
    SELECT 
        industry_branch,
        payroll_year,
        AVG(average_salary) AS yearly_avg_salary 
    FROM t_denisa_bartonova_project_SQL_primary_final
    GROUP BY industry_branch, payroll_year
),
growth_calculation AS (
    SELECT 
        industry_branch,
        ((yearly_avg_salary::numeric / LAG(yearly_avg_salary) OVER (PARTITION BY industry_branch ORDER BY payroll_year)) - 1) * 100 AS growth_percentage
    FROM industry_yearly_averages
)
SELECT 
    industry_branch,
    ROUND(AVG(growth_percentage)::numeric, 2) AS avg_yearly_growth_pct,
    ROUND(MIN(growth_percentage)::numeric, 2) AS worst_year_pct,
    ROUND(MAX(growth_percentage)::numeric, 2) AS best_year_pct
FROM growth_calculation
WHERE growth_percentage IS NOT NULL
GROUP BY industry_branch
ORDER BY avg_yearly_growth_pct DESC;
        
WITH salary_extremes AS (
    -- KROK 1: Prumerna mzda za celou CR pro roky 2006 a 2018 
    SELECT 
        industry_branch,
        AVG(CASE WHEN payroll_year = 2006 THEN average_salary END) AS avg_salary_2006,
        AVG(CASE WHEN payroll_year = 2018 THEN average_salary END) AS avg_salary_2018
    FROM t_denisa_bartonova_project_SQL_primary_final
    GROUP BY industry_branch
)
-- KROK 2: Vypocet absolutniho rozdilu a celkoveho procentualniho narustu
SELECT 
    industry_branch,
    ROUND(avg_salary_2006::numeric, 0) AS salary_start_2006,
    ROUND(avg_salary_2018::numeric, 0) AS salary_end_2018,
    ROUND((avg_salary_2018 - avg_salary_2006)::numeric, 0) AS difference_czk,
    ROUND(((avg_salary_2018 / avg_salary_2006 - 1) * 100)::numeric, 2) AS total_growth_percentage
FROM salary_extremes
ORDER BY total_growth_percentage DESC;