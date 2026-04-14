/*
 * 4. Existuje rok, ve kterem byl mezirocni narust cen potravin vyrazne vyssi nez rust mezd (vetsi nez 10 %)? 
 */

WITH annual_averages AS (
    -- KROK 1: Prumerna mzda a ceny potravin pro kazdy rok
    SELECT 
        payroll_year,
        AVG(average_salary) AS avg_salary,
        AVG(food_price) AS avg_food_price
    FROM t_denisa_bartonova_project_SQL_primary_final
    GROUP BY payroll_year
),
yearly_growth AS (
    -- KROK 2: Vypocet procentualniho narustu
    SELECT 
        payroll_year,
        ROUND(
            ((avg_salary - LAG(avg_salary) OVER (ORDER BY payroll_year)) / 
            LAG(avg_salary) OVER (ORDER BY payroll_year) * 100)::numeric, 2
        ) AS salary_growth_pct,
        ROUND(
            ((avg_food_price - LAG(avg_food_price) OVER (ORDER BY payroll_year)) / 
            LAG(avg_food_price) OVER (ORDER BY payroll_year) * 100)::numeric, 2
        ) AS food_growth_pct
    FROM annual_averages
)
-- KROK 3: Finalni vyber
SELECT 
    payroll_year AS year,
    salary_growth_pct,
    food_growth_pct,
    (food_growth_pct - salary_growth_pct) AS growth_difference
FROM yearly_growth
--WHERE (food_growth_pct - salary_growth_pct) > 10
ORDER BY growth_difference DESC;